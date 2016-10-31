filter timestamp {"$(Get-Date -Format G): $_"}
$build_log = "C:\Build_Logs\build.log"
$install_log = "C:\Build_Logs\install_cloudbase-init.log"
$download_uri = "https://cloudbase.it/downloads/CloudbaseInitSetup_x64.msi"
$installer_path = "C:\Windows\Temp\cloudbaseinit.msi"

function Write-Log($msg) {
      Write-Output $msg | timestamp | Tee-Object -FilePath $build_log -append
}

function Get-Installer {
  $progressPreference = "silentlyContinue"
  Invoke-WebRequest -OutFile $installer_path $download_uri
}

function Install-Cloudbase {
  $p = Start-Process -PassThru -FilePath msiexec -ArgumentList "/i $installer_path /qn /l*v $install_log"
  Wait-Process -Id $p.id -Timeout 60
  if ($p.ExitCode -ne 0) {
      Write-Log "ERROR: problem encountered during cloudbase-init install"
  }
}

Write-Log "BEGIN: install_cloudbase_init.ps1"
Write-Log "Downloading Cloudbase-init from $download_uri"
Get-Installer
Write-Log "Installing Cloudbase-init"
Install-Cloudbase
Write-Log "END: install_cloudbase_init.ps1"
