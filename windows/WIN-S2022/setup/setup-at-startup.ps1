# Set error action preference to "Stop" to halt script execution upon encountering errors
$ErrorActionPreference = "Stop"

# Set TLS protocol to TLS 1.2 for secure communication
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Install-VMWareTools {
	# Define the download folder
	$downloadFolder = 'C:\install\'

	try {
		Write-Host "Initiating VMware Tools installation." -ForegroundColor Cyan

		# Create the download folder if it doesn't exist
		if (-not (Test-Path -Path $downloadFolder)) {
			New-Item -Path $downloadFolder -ItemType Directory | Out-Null
		} else {
			Write-Host "Folder '$downloadFolder' already exists." -ForegroundColor Yellow
		}

		# Download the latest VMware Tools
		# Check the latest release by using the following link:
		# https://packages.vmware.com/tools/releases/latest/windows/x64/
		$url = "https://packages.vmware.com/tools/releases/latest/windows/x64/"
		$vmwareUrl = (Invoke-WebRequest -Uri $url -UseBasicParsing).Links | Where-Object { $_.Href -match "VM*" } | Select-Object -ExpandProperty href
		$downloadUrl = $url + $vmwareUrl
		$downloadPath = Join-Path -Path $downloadFolder -ChildPath $vmwareUrl
		(New-Object System.Net.WebClient).DownloadFile($downloadUrl, $downloadPath)

		# Install VMware Tools
		Start-Process -Wait `
			-FilePath $downloadPath `
			-ArgumentList '/S /v"/qn REBOOT=R" /l c:\windows\temp\vmware_tools_install.log'

		Write-Host "VMware Tools installed successfully." -ForegroundColor Green
	} catch {
		Write-Host "Error occurred during VMware Tools installation: $_" -ForegroundColor Red
		throw
	}
}

# function Enable-RDP() {
# 	Write-Host "Enabling RDP..." -ForegroundColor Cyan
# 	cmd /c netsh firewall set service remoteDesktop enable
# 	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
# 	Write-Host "RDP successfully enabled." -ForegroundColor Green
# }

function Disable-CPUThrottling() {
	Write-Host "Disabling CPU throttling..." -ForegroundColor Cyan
	# Set the active power scheme to "High performance"
	Powercfg -SetActive SCHEME_MIN
	Write-Host "CPU throttling successfully disabled." -ForegroundColor Green
}

function Install-PowerShell {
    try {
        Write-Host "Initiating PowerShell installation." -ForegroundColor Cyan

        # Download the installation script
        $installScript = Invoke-RestMethod -Uri "https://aka.ms/install-powershell.ps1"

        # Execute the installation script with parameters for silent installation
        Invoke-Expression "& { $installScript } -UseMSI"
        Write-Host "PowerShell installation completed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error occurred during PowerShell installation: $_" -ForegroundColor Red
		throw
    }
}

function Set-NetworkInPrivate() {
    Write-Host "Setting network to Private..." -ForegroundColor Cyan
    Set-NetConnectionProfile -NetworkCategory Private
    Write-Host "Network successfully configured to Private." -ForegroundColor Green
}

function Set-ExplorerSettings() {
	Write-Host "Initializing Explorer settings..." -ForegroundColor Cyan

	# Show hidden files
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1
	# Show file extensions
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0

	Stop-Process -Name explorer
	Start-Process -FilePath explorer
	Write-Host "Explorer settings initialized successfully." -ForegroundColor Green
}

function Update-Windows {
	try {
        Write-Host "Initiating Windows updates installation." -ForegroundColor Cyan

		# Check if the PSWindowsUpdate module is installed
		if (-not (Get-Module -Name PSWindowsUpdate -ListAvailable)) {
			Install-Module -Name PSWindowsUpdate -Force
		}

		# Check if the PSWindowsUpdate module is imported
		if (-not (Get-Module -Name PSWindowsUpdate)) {
			Import-Module -Name PSWindowsUpdate
		}

		# Get information about available Windows updates
		Get-WindowsUpdate

		# Install Windows updates using Microsoft Update, accepting all updates and enabling auto-reboot if needed
		Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot

		Write-Host "Windows updates installed successfully." -ForegroundColor Green
	} catch {
		Write-Host "Error occurred during Windows update process: $_" -ForegroundColor Red
		throw
	}
}

function Set-Wallpaper() {
	Write-Host "Setting new wallpaper..." -ForegroundColor Cyan

    $URL = "https://source.unsplash.com/featured/2560x1440/?landscape"

    $LastProgressPreference = $ProgressPreference
    $ProgressPreference = "Silent"

	# Download a random landscape image
    $ImagePath = "$HOME\Pictures\wallpaper.jpg"
    Invoke-WebRequest -Uri $URL -Outfile $ImagePath -UseBasicParsing

    $ProgressPreference = $LastProgressPreference

$setwallpapersrc = @"
using System.Runtime.InteropServices;

public class Wallpaper
{
    public const int SetDesktopWallpaper = 20;
    public const int UpdateIniFile = 0x01;
    public const int SendWinIniChange = 0x02;
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    public static void SetWallpaper(string path)
    {
    SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
    }
}
"@
    Add-Type -TypeDefinition $setwallpapersrc

    [Wallpaper]::SetWallpaper($ImagePath)
	Write-Host "New wallpaper successfully set." -ForegroundColor Green
}

Install-VMWareTools
# Enable-RDP
Disable-CPUThrottling
Install-PowerShell
Set-NetworkInPrivate
Set-ExplorerSettings
# Update-Windows
# Set-Wallpaper
