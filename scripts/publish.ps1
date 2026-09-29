# publish.ps1 —— 发布前检查（双分支时代：main 公开内容 + vault 私密密文）
#
# 用法：
#   pwsh -File scripts/publish.ps1                       # 发布前检查（不推送）
#   pwsh -File scripts/publish.ps1 -AutoPush             # 检查通过后自动 push origin main + origin vault
#   pwsh -File scripts/publish.ps1 -Message "chore: ..." # 配合 -AutoPush 的 commit message（只提交 main）
#   pwsh -File scripts/publish.ps1 -VaultPath "<vault 工作区路径>"
#
# vault 工作区路径：不给则默认取主工作区的**并列目录** `<仓库名>-vault`；
#   可用 `git worktree add <路径> vault` 创建（见 vault 分支的 README.md）。
#
# 检查项（v11.4：7 项）：
#   1) 主工作区干净（有未提交改动则中止——发布必须基于已提交状态）
#   2) _private 明文与口令被 .gitignore 排除（含子目录产物；防泄露）
#   3) 明文 ↔ vault 密文同步（每个 .md 在 vault 有对应 .enc 且不旧于明文；vault 里无多余密文）
#   4) 版本号一致（docs/CREATION-LOG.md 顶部 == SKILL.md 版本表尾部）
#   5) 主工作区**零**跟踪 _private（连 .enc 也不该有——密文全部在 vault）
#   6) vault 分支干净且无明文（工作区 _private/ 下只有 .enc；git 跟踪里无明文；工作区无未提交改动）
#   7) npm 包内容断言：npm pack --dry-run 的文件清单不得含 _private/scripts/AGENTS.md/.github

param(
    [switch]$AutoPush,
    [string]$Message = "",
    [string]$VaultPath = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$fail = @()

# vault 工作区定位（默认：并列目录 <仓库名>-vault）
if (-not $VaultPath) {
    $VaultPath = Join-Path (Split-Path -Parent $root) ((Split-Path -Leaf $root) + "-vault")
}
$vaultOk = (Test-Path $VaultPath) -and (Test-Path (Join-Path $VaultPath ".git"))
$vaultPrivate = Join-Path $VaultPath "_private"

# 1) 主工作区干净
Write-Host "== 1/7 主工作区状态 =="
$dirty = git -C $root status --porcelain
if ($dirty) {
    $fail += "主工作区有未提交改动，请先 commit 再发布：`n$dirty"
} else {
    Write-Host "  OK: 主工作区干净"
}

# 2) 明文忽略（含子目录产物与口令）
Write-Host "== 2/7 私密明文隔离 =="
foreach ($f in @("_private/ISSUES.md", "_private/ROADMAP.md", "_private/DEVELOPER.md", "_private/.secret", "_private/ISSUES.md.enc")) {
    if (Test-Path (Join-Path $root $f)) {
        if (git -C $root check-ignore $f 2>$null) {
            Write-Host "  OK: $f 被 .gitignore 排除"
        } else {
            $fail += "$f 未被 .gitignore 排除（泄露风险）"
        }
    }
}

# 3) 明文 ↔ vault 密文同步
Write-Host "== 3/7 明密文同步（主工作区明文 ↔ vault 密文）=="
if (-not $vaultOk) {
    $fail += "找不到 vault 工作区（$VaultPath）——先跑 git worktree add `"$VaultPath`" vault，或用 -VaultPath 指定"
} else {
    $private = Join-Path $root "_private"
    if (Test-Path $private) {
        $plain = Get-ChildItem $private -Filter "*.md" -File
        foreach ($md in $plain) {
            $enc = Join-Path $vaultPrivate "$($md.Name).enc"
            if (-not (Test-Path $enc)) {
                $fail += "缺密文：$($md.Name).enc 不在 vault（跑 scripts/secret.ps1 -Action encrypt -Path _private -OutDir `"$vaultPrivate`"）"
            } elseif ($md.LastWriteTime -gt (Get-Item $enc).LastWriteTime) {
                $fail += "密文过期：$($md.Name).enc 早于明文（重新加密到 vault）"
            } else {
                Write-Host "  OK: $($md.Name) -> vault/$($md.Name).enc 同步"
            }
        }
        # vault 里不该有多余密文
        if (Test-Path $vaultPrivate) {
            foreach ($enc in Get-ChildItem $vaultPrivate -Filter "*.enc" -File) {
                $name = $enc.Name -replace "\.enc$", ""
                if ($name -match "\.md$" -and -not (Test-Path (Join-Path $private $name))) {
                    $fail += "vault 有密文但主工作区无对应明文：$($enc.Name)（补明文或删密文）"
                }
            }
        }
    } else {
        $fail += "_private/ 目录不存在"
    }
}

# 4) 版本号一致
Write-Host "== 4/7 版本号一致 =="
$logVer = (Select-String -Path (Join-Path $root "docs/CREATION-LOG.md") -Pattern "^\| (v[0-9.]+)" | Select-Object -First 1).Matches[0].Groups[1].Value
$skillVer = (Select-String -Path (Join-Path $root "SKILL.md") -Pattern "^\| (v[0-9.]+)" | Select-Object -Last 1).Matches[0].Groups[1].Value
Write-Host "  CREATION-LOG 顶部: $logVer | SKILL.md 版本表尾: $skillVer"
if ($logVer -ne $skillVer) { $fail += "版本号不一致：CREATION-LOG=$logVer, SKILL.md=$skillVer" }
$npmVer = (Get-Content (Join-Path $root "package.json") -Raw | ConvertFrom-Json).version
Write-Host "  package.json version: $npmVer（发布前先 npm view new-project-init version --registry https://registry.npmjs.org 确认 registry 实际版本）"

# 5) 主工作区零跟踪 _private
Write-Host "== 5/7 主工作区零跟踪 _private =="
$tracked = git -C $root -c core.quotepath=false ls-files "_private"
if ($tracked) {
    $fail += "主工作区仍跟踪 _private 文件（v11.4 起应为零——密文全在 vault）：$($tracked -join ', ')"
} else {
    Write-Host "  OK: 主工作区未跟踪任何 _private 文件（密文全在 vault）"
}

# 6) vault 分支干净且无明文
Write-Host "== 6/7 vault 分支无明文 =="
if (-not $vaultOk) {
    Write-Host "  SKIP: 无 vault 工作区"
} else {
    $vdirty = git -C $VaultPath status --porcelain
    if ($vdirty) { $fail += "vault 工作区有未提交改动（密文改动要单独提交到 vault）：`n$vdirty" }
    $vtracked = git -C $VaultPath -c core.quotepath=false ls-files "_private" | Where-Object { $_ -notmatch "\.enc$" }
    if ($vtracked) { $fail += "vault 已跟踪明文：$($vtracked -join ', ')" }
    $vonDisk = @()
    if (Test-Path $vaultPrivate) {
        $vonDisk = Get-ChildItem $vaultPrivate -File | Where-Object { $_.Name -notmatch "\.enc$" }
    }
    if ($vonDisk) {
        $fail += "vault 工作区 _private/ 下有非密文文件（有误提交风险）：$($vonDisk.Name -join ', ')"
    } else {
        Write-Host "  OK: vault 分支跟踪与磁盘均只有 *.enc"
    }
}

# 7) npm 包内容断言
Write-Host "== 7/7 npm 包内容断言 =="
$npmCmd = Get-Command npm -ErrorAction SilentlyContinue
if (-not $npmCmd) {
    Write-Host "  SKIP: 未找到 npm（发布前请在有 npm 的机器上重跑本检查）"
} else {
    $forbidden = @("_private/", "scripts/", "AGENTS.md", ".github/")
    try {
        $packJson = & npm pack --dry-run --json 2>$null | Out-String
        $packData = $packJson | ConvertFrom-Json
        $paths = @($packData[0].files | ForEach-Object { $_.path })
        $bad = @($paths | Where-Object { $p = $_; $forbidden | Where-Object { $p -like "$_*" } })
        if ($bad) {
            $fail += "npm 包含禁止内容（检查 package.json 的 files 白名单）：$($bad -join ', ')"
        } else {
            Write-Host "  OK: npm 包共 $($paths.Count) 个文件，不含 $($forbidden -join ' / ')"
        }
    } catch {
        $fail += "npm pack --dry-run 执行失败：$($_.Exception.Message)"
    }
}

# 汇总
Write-Host "================================"
if ($fail) {
    Write-Host "❌ 发布前检查未通过："
    $fail | ForEach-Object { Write-Host "  - $_" }
    exit 1
}
Write-Host "✅ 发布前检查通过。发布 = 推两个分支："
Write-Host "     git -C `"$root`" push origin main     # 公开内容（skill 本体）"
Write-Host "     git -C `"$VaultPath`" push origin vault  # 私密密文"

if ($AutoPush) {
    if ($Message) {
        git -C $root commit --allow-empty -m $Message 2>&1 | Out-Host
    }
    Write-Host "== 推送 origin/main（公开内容）=="
    git -C $root push origin main 2>&1 | Out-Host
    if ($vaultOk) {
        Write-Host "== 推送 origin/vault（私密密文）=="
        git -C $VaultPath push origin vault 2>&1 | Out-Host
    }
    Write-Host "== 发布完成 =="
} else {
    Write-Host "（提示：加 -AutoPush 可自动推送两个分支）"
}
