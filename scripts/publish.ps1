# publish.ps1 —— 发布前检查（单仓库时代：GitHub push 即发布）
#
# 用法：
#   pwsh -File scripts/publish.ps1               # 发布前检查（不推送）
#   pwsh -File scripts/publish.ps1 -AutoPush     # 检查通过后自动 git push origin main
#   pwsh -File scripts/publish.ps1 -Message "chore: 发布 v10.x ..."   # 配合 -AutoPush 的 commit message
#
# 检查项：
#   1) git 工作区干净（有未提交改动则中止——发布必须基于已提交状态）
#   2) _private 明文与口令被 .gitignore 排除（防泄露）
#   3) 密文与明文同步（每个 .md 有对应 .enc 且 .enc 不旧于明文）
#   4) 版本号一致（docs/CREATION-LOG.md 顶部 == SKILL.md 版本表尾部）
#   5) git 跟踪中无 _private 明文（只允许 *.enc 密文）

param(
    [switch]$AutoPush,
    [string]$Message = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$fail = @()

# 1) 工作区干净
Write-Host "== 1/5 工作区状态 =="
$dirty = git -C $root status --porcelain
if ($dirty) {
    $fail += "工作区有未提交改动，请先 commit 再发布：`n$dirty"
} else {
    Write-Host "  OK: 工作区干净"
}

# 2) 明文忽略
Write-Host "== 2/5 私密明文隔离 =="
foreach ($f in @("_private/ISSUES.md", "_private/ROADMAP.md", "_private/DEVELOPER.md", "_private/.secret")) {
    if (Test-Path (Join-Path $root $f)) {
        if (git -C $root check-ignore $f 2>$null) {
            Write-Host "  OK: $f 被 .gitignore 排除"
        } else {
            $fail += "$f 未被 .gitignore 排除（泄露风险）"
        }
    }
}

# 3) 密文同步
Write-Host "== 3/5 密文明文同步 =="
$private = Join-Path $root "_private"
if (Test-Path $private) {
    foreach ($md in Get-ChildItem $private -Filter "*.md" -File) {
        $enc = "$($md.FullName).enc"
        if (-not (Test-Path $enc)) {
            $fail += "缺密文：$($md.Name).enc（先跑 scripts/secret.ps1 -Action encrypt）"
        } elseif ($md.LastWriteTime -gt (Get-Item $enc).LastWriteTime) {
            $fail += "密文过期：$($md.Name).enc 早于明文（重新加密）"
        } else {
            Write-Host "  OK: $($md.Name) -> .enc 同步"
        }
    }
    foreach ($enc in Get-ChildItem $private -Filter "*.enc" -File) {
        $md = $enc.FullName -replace "\.enc$", ""
        if (-not (Test-Path $md)) {
            $fail += "密文无对应明文：$($enc.Name)（补明文或删密文）"
        }
    }
} else {
    $fail += "_private/ 目录不存在"
}

# 4) 版本号一致
Write-Host "== 4/5 版本号一致 =="
$logVer = (Select-String -Path (Join-Path $root "docs/CREATION-LOG.md") -Pattern "^\| (v[0-9.]+)" | Select-Object -First 1).Matches[0].Groups[1].Value
$skillVer = (Select-String -Path (Join-Path $root "SKILL.md") -Pattern "^\| (v[0-9.]+)" | Select-Object -Last 1).Matches[0].Groups[1].Value
Write-Host "  CREATION-LOG 顶部: $logVer | SKILL.md 版本表尾: $skillVer"
if ($logVer -ne $skillVer) { $fail += "版本号不一致：CREATION-LOG=$logVer, SKILL.md=$skillVer" }
$npmVer = (Get-Content (Join-Path $root "package.json") -Raw | ConvertFrom-Json).version
Write-Host "  package.json version: $npmVer（npm 已恢复发布，当前 1.1.0）"

# 5) git 跟踪无明文
Write-Host "== 5/5 git 跟踪无明文 =="
$tracked = git -C $root ls-files "_private" | Where-Object { $_ -match "\.md$" -and $_ -notmatch "\.enc$" }
if ($tracked) {
    $fail += "git 已跟踪 _private 明文：$tracked"
} else {
    Write-Host "  OK: _private 无明文被跟踪（仅密文 .enc）"
}

# 汇总
Write-Host "================================"
if ($fail) {
    Write-Host "❌ 发布前检查未通过："
    $fail | ForEach-Object { Write-Host "  - $_" }
    exit 1
}
Write-Host "✅ 发布前检查通过：git push origin main 即发布（GitHub）"

if ($AutoPush) {
    if ($Message) {
        git -C $root commit --allow-empty -m $Message 2>&1 | Out-Host
    }
    Write-Host "== 推送 origin/main（public）=="
    git -C $root push origin main 2>&1 | Out-Host
    Write-Host "== 发布完成 =="
} else {
    Write-Host "（提示：加 -AutoPush 可自动推送，或手动 git push origin main）"
}
