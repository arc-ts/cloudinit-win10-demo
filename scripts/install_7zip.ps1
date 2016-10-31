filter timestamp {"$(Get-Date -Format G): $_"}
$build_log = "C:\Build_Logs\build.log"
$install_log = "C:\Build_logs\install_7zip.log"
$download_uri = "http://www.7-zip.org/a/7z1604-x64.msi"
$installer_path = "C:\Windows\Temp\7zip.msi"

function Write-Log($msg) {
      Write-Output $msg | timestamp | Tee-Object -FilePath $build_log -append
}



function Get-Installer {
  $progressPreference = "silentlyContinue"
  Invoke-WebRequest -OutFile $installer_path $download_uri
}

function Install-7zip {
  $p = Start-Process -PassThru -FilePath msiexec -ArgumentList "/qb $installer_path /qn /l*v $install_log"
  Wait-Process -Id $p.id -Timeout 60
  if ($p.ExitCode -ne 0) {
      Write-Log "ERROR: problem encountered during 7zip install"
  }
}

Write-Log "BEGIN: install_7zip.ps1"
Write-Log "Downloading 7zip from $cloudbase_uri"
Get-Installer
Write-Log "Installing 7zip"
Install-7zip
Write-Log "END: install_7zip.ps1"
