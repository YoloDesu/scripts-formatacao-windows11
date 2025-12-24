#requires -RunAsAdministrator
<#
Win11 Post-Install Script
- Installs apps via winget
- Enables .NET 3.5
- Installs VC++ 2015-2022
- Installs MSYS2 + MinGW-w64 toolchain
- Ensures PATH for ffmpeg + node (+ mingw)
- Restarts at end
#>

$ErrorActionPreference = "Stop"

# -------------------- Helpers --------------------
function Write-Section($msg) {
  Write-Host ""
  Write-Host "==================== $msg ====================" -ForegroundColor Cyan
}

function Ensure-Admin {
  $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  if (-not $isAdmin) {
    throw "Execute este script como Administrador (Run as Administrator)."
  }
}

function Ensure-Winget {
  if (Get-Command winget -ErrorAction SilentlyContinue) { return }

  Write-Host "winget não encontrado. Tentando instalar/ativar App Installer..." -ForegroundColor Yellow
  # Tenta disparar instalaaoo do App Installer (Microsoft.DesktopAppInstaller) via ms-store protocol
  Start-Process "ms-windows-store://pdp/?productid=9NBLGGH4NNS1" | Out-Null
  Write-Host "Abra a Microsoft Store (App Installer) e instale. Depois rode o script novamente." -ForegroundColor Yellow
  throw "winget ausente."
}

function Is-WingetIdInstalled([string]$Id) {
  try {
    $out = winget list --id $Id -e --accept-source-agreements 2>$null | Out-String
    return ($out -match [regex]::Escape($Id))
  } catch {
    return $false
  }
}

function Winget-Install([string]$Id, [string]$Name, [string]$ExtraArgs = "") {
  if (Is-WingetIdInstalled $Id) {
    Write-Host "OK Ja instalado: $Name ($Id)" -ForegroundColor Green
    return $true
  }

  Write-Host "Instalando: $Name ($Id)" -ForegroundColor White
  $args = @("install","--id",$Id,"-e",
            "--silent",
            "--accept-package-agreements","--accept-source-agreements")
  if ($ExtraArgs -and $ExtraArgs.Trim().Length -gt 0) {
    $args += @("--override", $ExtraArgs)
  }

  try {
    winget @args | Out-Host
    return $true
  } catch {
    Write-Host "Falhou: $Name ($Id)" -ForegroundColor Red
    return $false
  }
}

function Try-InstallAnyId([string[]]$Ids, [string]$Name, [string]$ExtraArgs = "") {
  foreach ($id in $Ids) {
    if ([string]::IsNullOrWhiteSpace($id)) { continue }
    if (Winget-Install -Id $id -Name $Name -ExtraArgs $ExtraArgs) { return $true }
  }
  return $false
}

function Add-ToMachinePath([string]$dir) {
  if (-not (Test-Path $dir)) { return $false }

  $current = [Environment]::GetEnvironmentVariable("Path", "Machine")
  $parts = $current -split ";" | Where-Object { $_ -and $_.Trim() -ne "" }
  if ($parts -contains $dir) {
    Write-Host "OK PATH ja contem: $dir" -ForegroundColor Green
    return $true
  }

  $new = ($parts + $dir) -join ";"
  [Environment]::SetEnvironmentVariable("Path", $new, "Machine")
  Write-Host "Adicionado ao PATH (Machine): $dir" -ForegroundColor Yellow
  return $true
}

function Find-ExeDir([string]$exeName, [string[]]$searchRoots) {
  foreach ($root in $searchRoots) {
    if (-not (Test-Path $root)) { continue }
    try {
      $hit = Get-ChildItem -Path $root -Filter $exeName -Recurse -ErrorAction SilentlyContinue |
             Select-Object -First 1
      if ($hit) { return $hit.Directory.FullName }
    } catch {}
  }
  return $null
}

# -------------------- Main --------------------
Ensure-Admin
Ensure-Winget

Write-Section "Habilitar .NET 3.5"
try {
  $netfx = (Get-WindowsOptionalFeature -Online -FeatureName NetFx3)
  if ($netfx.State -eq "Enabled") {
    Write-Host "OK .NET 3.5 ja esta habilitado." -ForegroundColor Green
  } else {
    Write-Host "Habilitando .NET 3.5 (NetFx3)..." -ForegroundColor White
    DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /NoRestart | Out-Host
  }
} catch {
  Write-Host "⚠ Não consegui habilitar o .NET 3.5 automaticamente. Pode exigir Windows Update/midia de instalaaoo." -ForegroundColor Yellow
}

Write-Section "Instalar Visual C++ Redistributable (2015 2022)"
Try-InstallAnyId -Name "Microsoft Visual C++ 2015 2022 (x64)" -Ids @(
  "Microsoft.VCRedist.2015+.x64",
  "Microsoft.VCRedist.2015-2022.x64"
) | Out-Null

Try-InstallAnyId -Name "Microsoft Visual C++ 2015 2022 (x86)" -Ids @(
  "Microsoft.VCRedist.2015+.x86",
  "Microsoft.VCRedist.2015-2022.x86"
) | Out-Null

Write-Section "Apps principais (winget)"
# Floorp (IDs podem variar)
Try-InstallAnyId -Name "Floorp" -Ids @(
  "Ablaze.Floorp",
  "Floorp.Floorp"
) | Out-Null

Winget-Install -Id "Valve.Steam" -Name "Steam" | Out-Null
Winget-Install -Id "EpicGames.EpicGamesLauncher" -Name "Epic Games Launcher" | Out-Null
Winget-Install -Id "VideoLAN.VLC" -Name "VLC" | Out-Null
Winget-Install -Id "Discord.Discord" -Name "Discord" | Out-Null

# FFmpeg (IDs podem variar)
Try-InstallAnyId -Name "FFmpeg" -Ids @(
  "Gyan.FFmpeg",
  "FFmpeg.FFmpeg"
) | Out-Null

Winget-Install -Id "Git.Git" -Name "Git" | Out-Null
Winget-Install -Id "Microsoft.VisualStudioCode" -Name "Visual Studio Code" | Out-Null

# Visual Studio (Native Desktop = C/C++)
# (Se quiser outros workloads depois, da pra estender o override.)
$vsOverride = '--add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended --passive --norestart'
Try-InstallAnyId -Name "Visual Studio 2022 Community" -Ids @(
  "Microsoft.VisualStudio.2022.Community"
) -ExtraArgs $vsOverride | Out-Null

# Node.js
Try-InstallAnyId -Name "Node.js LTS" -Ids @(
  "OpenJS.NodeJS.LTS",
  "OpenJS.NodeJS"
) | Out-Null

# qBittorrent
Winget-Install -Id "qBittorrent.qBittorrent" -Name "qBittorrent" | Out-Null

# Vulkan SDK
Winget-Install -Id "KhronosGroup.VulkanSDK" -Name "Vulkan SDK" | Out-Null

Write-Section "AMD Adrenalin (tentativa via winget + fallback)"
$amdOk = Try-InstallAnyId -Name "AMD Software: Adrenalin Edition" -Ids @(
  "AdvancedMicroDevices.AMDSoftware",
  "AMD.AMDSoftware",
  "AMD.RadeonSoftware"
)
if (-not $amdOk) {
  Write-Host "Nao achei um ID winget confiavel para o Adrenalin no seu ambiente." -ForegroundColor Yellow
  Write-Host "Abrindo a pagina oficial da AMD para baixar o driver/Adrenalin..." -ForegroundColor White
  Start-Process "https://www.amd.com/en/support"
}

Write-Section "MinGW (via MSYS2 + mingw-w64 gcc/g++)"
# Instala MSYS2
$msysOk = Try-InstallAnyId -Name "MSYS2" -Ids @("MSYS2.MSYS2","MSYS2.MSYS2Installer")
if ($msysOk) {
  $bash = "C:\msys64\usr\bin\bash.exe"
  if (Test-Path $bash) {
    Write-Host "Atualizando MSYS2 e instalando toolchain mingw-w64..." -ForegroundColor White
    # Atualiza e instala gcc/g++/gdb/make (sem prompts)
    & $bash -lc "pacman -Syu --noconfirm" | Out-Host
    & $bash -lc "pacman -S --needed --noconfirm mingw-w64-x86_64-toolchain mingw-w64-x86_64-gdb mingw-w64-x86_64-make" | Out-Host
  } else {
    Write-Host "MSYS2 instalado, mas bash.exe não encontrado em C:\msys64. Verifique o caminho." -ForegroundColor Yellow
  }
}

Write-Section "Garantir PATH (ffmpeg, node, mingw)"
# Node geralmente fica em C:\Program Files\nodejs
Add-ToMachinePath "C:\Program Files\nodejs" | Out-Null

# MinGW (MSYS2)
Add-ToMachinePath "C:\msys64\mingw64\bin" | Out-Null

# FFmpeg: tenta achar automaticamente em locais comuns
$ffDir = Find-ExeDir -exeName "ffmpeg.exe" -searchRoots @(
  "C:\Program Files",
  "C:\Program Files (x86)",
  "C:\ProgramData\chocolatey\bin",
  "$env:LOCALAPPDATA",
  "$env:ProgramData"
)
if ($ffDir) {
  Add-ToMachinePath $ffDir | Out-Null
} else {
  # fallback comum do Gyan
  Add-ToMachinePath "C:\Program Files\FFmpeg\bin" | Out-Null
  Add-ToMachinePath "C:\ffmpeg\bin" | Out-Null
}

Write-Section "Resumo e Reinicio"
Write-Host "OK Script finalizado. Agora vou reiniciar para garantir PATH e setups concluidos." -ForegroundColor Green

Start-Sleep -Seconds 5
Restart-Computer -Force
