# secret.ps1 —— 私密文件 AES-GCM 加解密（零外部依赖，PowerShell 7 / .NET 内置）
#
# 用途：ISSUES.md / ROADMAP.md / DEVELOPER.md 等私密明文不进 GitHub 仓库，
#       加密产物 *.enc 提交（密文公开无妨）；两台电脑用同一口令解密使用。
#
# 用法：
#   pwsh -File scripts/secret.ps1 -Action encrypt -Path _private/ISSUES.md
#   pwsh -File scripts/secret.ps1 -Action encrypt -Path _private            # 目录：处理全部 *.md
#   pwsh -File scripts/secret.ps1 -Action decrypt -Path _private/ISSUES.md.enc
#   pwsh -File scripts/secret.ps1 -Action decrypt -Path _private -Recurse   # 递归还原
#   pwsh -File scripts/secret.ps1 -Action encrypt -Path _private -Passphrase "你的口令"
#
# 口令来源（优先级从高到低）：
#   1) -Passphrase 参数
#   2) 环境变量 NPI_SECRET
#   3) _private/.secret 文件（首行内容；该文件已被 .gitignore 排除，勿提交）
#
# 文件格式：Base64("NPI1" + salt(16) + nonce(12) + tag(16) + ciphertext)
#   - salt 随机 → PBKDF2 派生 key（防彩虹表）；nonce 随机；GCM 自带完整性认证
#   - 解密失败（口令错/文件损坏）会抛 CryptographicException，不会产出错误明文

param(
    [Parameter(Mandatory = $true)][ValidateSet("encrypt", "decrypt")][string]$Action,
    [Parameter(Mandatory = $true)][string]$Path,
    [string]$Passphrase = "",
    [switch]$Recurse
)

$ErrorActionPreference = "Stop"

# ---------- 口令 ----------
function Get-Secret {
    if ($Passphrase) { return $Passphrase }
    if ($env:NPI_SECRET) { return $env:NPI_SECRET }
    $secretFile = Join-Path (Split-Path -Parent $PSScriptRoot) "_private\.secret"
    if (Test-Path $secretFile) {
        $line = (Get-Content $secretFile -TotalCount 1).Trim()
        if ($line) { return $line }
    }
    throw "未提供口令：用 -Passphrase，或设环境变量 NPI_SECRET，或写 _private/.secret（不入库）"
}

# ---------- 派生 key（PBKDF2-SHA256） ----------
function Get-Key([byte[]]$salt, [string]$pass) {
    $pbkdf2 = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($pass, $salt, 100000, [System.Security.Cryptography.HashAlgorithmName]::SHA256)
    return $pbkdf2.GetBytes(32)
}

# ---------- 加密单个文件 ----------
function Encrypt-File([string]$file, [string]$pass) {
    $plain = [System.IO.File]::ReadAllBytes($file)
    $salt = [byte[]]::new(16);   [System.Security.Cryptography.RandomNumberGenerator]::Fill($salt)
    $nonce = [byte[]]::new(12);  [System.Security.Cryptography.RandomNumberGenerator]::Fill($nonce)
    $key = Get-Key $salt $pass
    $cipher = [byte[]]::new($plain.Length)
    $tag = [byte[]]::new(16)
    $aes = [System.Security.Cryptography.AesGcm]::new($key, 16)
    try { $aes.Encrypt($nonce, $plain, $cipher, $tag) } finally { $aes.Dispose() }
    $magic = [System.Text.Encoding]::ASCII.GetBytes("NPI1")
    $payload = $magic + $salt + $nonce + $tag + $cipher
    $out = "$file.enc"
    [System.IO.File]::WriteAllText($out, [Convert]::ToBase64String($payload))
    Write-Host "  encrypt: $file -> $out ($($plain.Length) B -> $([Convert]::ToBase64String($payload).Length) chars)"
}

# ---------- 解密单个 .enc ----------
function Decrypt-File([string]$file, [string]$pass) {
    $b64 = [System.IO.File]::ReadAllText($file).Trim()
    $payload = [Convert]::FromBase64String($b64)
    $magic = [System.Text.Encoding]::ASCII.GetBytes("NPI1")
    if ($payload.Length -lt ($magic.Length + 16 + 12 + 16)) { throw "格式非法（太短）：$file" }
    for ($i = 0; $i -lt $magic.Length; $i++) { if ($payload[$i] -ne $magic[$i]) { throw "格式非法（缺 NPI1 头）：$file" } }
    $offset = $magic.Length
    $salt = $payload[$offset..($offset + 15)];                    $offset += 16
    $nonce = $payload[$offset..($offset + 11)];                   $offset += 12
    $tag = $payload[$offset..($offset + 15)];                     $offset += 16
    $cipher = $payload[$offset..($payload.Length - 1)]
    $key = Get-Key $salt $pass
    $plain = [byte[]]::new($cipher.Length)
    $aes = [System.Security.Cryptography.AesGcm]::new($key, 16)
    try { $aes.Decrypt($nonce, $cipher, $tag, $plain) } finally { $aes.Dispose() }
    $out = $file -replace "\.enc$", ""
    [System.IO.File]::WriteAllBytes($out, $plain)
    Write-Host "  decrypt: $file -> $out ($($plain.Length) B)"
}

# ---------- 收集目标文件 ----------
if (Test-Path $Path -PathType Leaf) {
    $targets = @($Path)
} elseif (Test-Path $Path -PathType Container) {
    if ($Action -eq "encrypt") {
        $targets = @(Get-ChildItem -Path $Path -Filter "*.md" -Recurse:$Recurse | Where-Object { $_.FullName -notlike "*.enc" } | ForEach-Object { $_.FullName })
    } else {
        $targets = @(Get-ChildItem -Path $Path -Filter "*.enc" -Recurse:$Recurse | ForEach-Object { $_.FullName })
    }
} else {
    throw "路径不存在：$Path"
}

if (-not $targets) { Write-Host "没有匹配的 $($Action) 目标文件（$Path）"; exit 0 }

$pass = Get-Secret
Write-Host "== secret.ps1 - $Action ($($targets.Count) 个文件) =="

if ($Action -eq "encrypt") {
    foreach ($f in $targets) { Encrypt-File $f $pass }
} else {
    foreach ($f in $targets) { Decrypt-File $f $pass }
}

Write-Host "== 完成 =="
