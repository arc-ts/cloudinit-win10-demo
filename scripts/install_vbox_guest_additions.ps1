filter timestamp {"$(Get-Date -Format G): $_"}
$build_log = "C:\Build_logs\build.log"

function Write-Log($msg) {
    Write-Output $msg | timestamp | Tee-Object -FilePath $build_log -append
}

function Add-OracleCert {
  $p = Start-Process -PassThru -FilePath certutil -ArgumentList "-addstore -f `"TrustedPublisher`" E:\cert\oracle-vbox.cer"
  Wait-Process -Id $p.id -Timeout 60
  if ($p.ExitCode -ne 0) {
    Write-Log "ERROR: problem encountered during Cert Addition"
  }
  return $p.ExitCode
}

function Install-VBoxGuestAdditions {
  $p = Start-Process -PassThru -FilePath E:\VBoxWindowsAdditions.exe -ArgumentList "/S"
  Wait-Process -Id $p.id -Timeout 60
  if ($p.ExitCode -ne 0) {
    Write-Log "ERROR: problem encountered during VBox Guest Additions Install"
  }
}

Write-Log "BEING: install_vbox_guest_additions.ps1"
Write-Log "Adding Oracle Cert"
$result = Add-OracleCert
Write-Log "Installing VBox Guest Additions"
if ($result -eq 0) { Install-VBoxGuestAdditions }
Write-Log "END: install_vbox_guest_additions.ps1"
