# ============================================================
# fix-wechat-devtools.ps1
# Fixes the HBuilderX <-> WeChat DevTools connection problem
# (e.g. "connect ECONNREFUSED 127.0.0.1:33774").
#
# Background:
#   HBuilderX talks to WeChat DevTools through DevTools' "service port".
#   - The port is DYNAMIC: it changes every time DevTools restarts.
#   - It only listens after being enabled once in:
#     DevTools -> Settings (gear) -> Security Settings -> "Service Port".
#   - ECONNREFUSED on a high port like 33774 means HBuilderX is using a
#     STALE port that no process is listening on anymore.
#
# What this script does:
#   1. Locates the WeChat DevTools installation (exe + cli.bat).
#   2. Reports every port the current DevTools processes listen on.
#   3. Kills all stale DevTools processes (exe + bundled node + watchers).
#   4. Restarts DevTools (optionally opens the compiled project).
#   5. Reports the NEW listening ports with a TCP connectivity test.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\fix-wechat-devtools.ps1 -Status
#   powershell -ExecutionPolicy Bypass -File .\fix-wechat-devtools.ps1
#   powershell -ExecutionPolicy Bypass -File .\fix-wechat-devtools.ps1 -OpenProject
# ============================================================

param(
    [switch]$Status,        # only report, do not kill/restart
    [switch]$OpenProject,   # also open the compiled project via cli.bat
    [string]$ProjectPath = "D:\Code\BlindAssistant\BlindAssistant\unpackage\dist\dev\mp-weixin"
)

$ErrorActionPreference = "Continue"

function Find-DevToolsDir {
    # 1) from a running process (most reliable)
    $proc = Get-Process wechatdevtools -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($proc -and $proc.Path) { return (Split-Path -Parent $proc.Path) }
    # 2) scan the user profile for a folder containing wechatdevtools.exe
    foreach ($d in Get-ChildItem -Path $env:USERPROFILE -Directory -ErrorAction SilentlyContinue) {
        if (Test-Path (Join-Path $d.FullName "wechatdevtools.exe")) { return $d.FullName }
    }
    # 3) standard install locations
    foreach ($base in @("${env:ProgramFiles(x86)}\Tencent", "$env:ProgramFiles\Tencent")) {
        if ($base -and (Test-Path $base)) {
            foreach ($d in Get-ChildItem -Path $base -Directory -ErrorAction SilentlyContinue) {
                if (Test-Path (Join-Path $d.FullName "wechatdevtools.exe")) { return $d.FullName }
            }
        }
    }
    return $null
}

function Get-DevToolsListenPorts {
    $ids = @(Get-Process wechatdevtools -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Id)
    if ($ids.Count -eq 0) { return @() }
    return @(Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
        Where-Object { $ids -contains $_.OwningProcess })
}

function Test-Port([int]$Port) {
    try {
        $c = New-Object System.Net.Sockets.TcpClient
        $r = $c.BeginConnect("127.0.0.1", $Port, $null, $null)
        $ok = $r.AsyncWaitHandle.WaitOne(1000)
        if ($ok -and $c.Connected) { $c.Close(); return $true }
        $c.Close()
    } catch {}
    return $false
}

function Show-Ports($caption) {
    Write-Host ""
    Write-Host "== $caption ==" -ForegroundColor Cyan
    $conns = Get-DevToolsListenPorts
    if ($conns.Count -eq 0) {
        Write-Host "  (no wechatdevtools process is listening on any port)" -ForegroundColor Yellow
        return @()
    }
    $ports = @($conns | Select-Object -ExpandProperty LocalPort -Unique | Sort-Object)
    foreach ($conn in $conns) {
        Write-Host ("  {0,-16} port {1,-6} pid {2}" -f $conn.LocalAddress, $conn.LocalPort, $conn.OwningProcess)
    }
    foreach ($port in $ports) {
        $ok = Test-Port ([int]$port)
        Write-Host ("  TCP connect test 127.0.0.1:{0} -> {1}" -f $port, $(if ($ok) { "OK" } else { "FAILED" }))
    }
    Write-Host "  (one of these ports is the 'service port' shown in DevTools Security Settings)"
    return $ports
}

# ---------------- main ----------------
Write-Host "WeChat DevTools connection fixer" -ForegroundColor Green

$dir = Find-DevToolsDir
if (-not $dir) {
    Write-Host "FATAL: WeChat DevTools not found (wechatdevtools.exe)." -ForegroundColor Red
    exit 1
}
Write-Host "DevTools install dir : $dir"
$exe = Join-Path $dir "wechatdevtools.exe"
$cli = Join-Path $dir "cli.bat"

Show-Ports "BEFORE: ports currently used by DevTools" | Out-Null

if ($Status) {
    Write-Host ""
    Write-Host "(-Status: nothing was changed.)"
    exit 0
}

# ---- kill every process running from the DevTools dir (exe + bundled node + watchers)
Write-Host ""
Write-Host "Stopping all WeChat DevTools processes..." -ForegroundColor Cyan
Get-Process -ErrorAction SilentlyContinue | Where-Object {
    $_.Path -and ($_.Path.ToLower().StartsWith($dir.ToLower() + "\"))
} | ForEach-Object {
    Write-Host ("  stopping {0} (pid {1})" -f $_.ProcessName, $_.Id)
    Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2

# ---- restart
Write-Host ""
Write-Host "Starting WeChat DevTools..." -ForegroundColor Cyan
Start-Process -FilePath $exe
Write-Host "  waiting for a listening port (up to 60s)..."

$deadline = (Get-Date).AddSeconds(60)
do {
    Start-Sleep -Seconds 3
    $ports = Get-DevToolsListenPorts
} while ($ports.Count -eq 0 -and (Get-Date) -lt $deadline)

Show-Ports "AFTER: ports used by the fresh DevTools instance" | Out-Null

# ---- optional: open the compiled project through the official CLI
if ($OpenProject) {
    Write-Host ""
    if (Test-Path $ProjectPath) {
        Write-Host "Opening project via cli: $ProjectPath" -ForegroundColor Cyan
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$cli`" open --project `"$ProjectPath`""
    } else {
        Write-Host "Project path not found: $ProjectPath" -ForegroundColor Yellow
        Write-Host "Compile once in HBuilderX first (Run -> Run to MP simulator)."
    }
}

# ---- summary / manual steps
Write-Host ""
Write-Host "================ MANUAL STEPS (one-time) ================" -ForegroundColor Green
Write-Host "1. In WeChat DevTools: Settings (gear) -> Security Settings -> ENABLE 'Service Port'."
Write-Host "2. Note the port shown there. It must match one of the 'AFTER' ports above."
Write-Host "   (If nothing listens: the service port toggle is OFF - enable it, then rerun this script.)"
Write-Host "3. In HBuilderX: Tools -> Settings -> Run Config -> Mini Program ->"
Write-Host "   WeChat DevTools path = $exe"
Write-Host "4. Fully quit HBuilderX (it caches the old port) and reopen it, then"
Write-Host "   Run -> Run to Mini Program Simulator -> WeChat DevTools."
Write-Host "5. Do NOT hand-edit unpackage\...\project.config.json - HBuilderX regenerates"
Write-Host "   it on every compile. Persistent settings go in manifest.json -> mp-weixin."
Write-Host "========================================================="
