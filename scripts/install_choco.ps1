filter timestamp {"$(Get-Date -Format G): $_"}
$build_log = "C:\Build_Logs\build.log"
$download_uri = "https://chocolatey.org/install.ps1"
$installer_path = "C:\Windows\Temp\install_chocolatey.ps1"

function Write-Log($msg) {
      Write-Output $msg | timestamp | Tee-Object -FilePath $build_log -append
}

function Get-Installer {
  $progressPreference = "silentlyContinue"
  Invoke-WebRequest -OutFile $installer_path $download_uri
}

function Install-Choco {
  Set-ExecutionPolicy RemoteSigned
  Invoke-Expression $installer_path
}

Write-Log "BEGIN: install_choco.ps1"
Write-Log "Downloading Chcolatey Installer"
Get-Installer
Write-Log "Installing Chocolatey"
Install-Choco
Write-Log "END: install_choco.ps1"
