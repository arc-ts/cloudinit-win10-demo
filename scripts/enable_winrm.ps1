filter timestamp {"$(Get-Date -Format G): $_"}
$build_log = "C:\Build_logs\build.log"

function Write-Log($msg) {
      Write-Output $msg | timestamp | Tee-Object -FilePath $build_log -append
}


function Add-WinRMFW {
  netsh advfirewall firewall set rule group="remote administration" new enable=yes
  netsh advfirewall firewall add rule name="WinRM" dir=in action=allow protocol=TCP localport=5985
}

function Enable-WinRM {
  winrm quickconfig -q
  winrm quickconfig -transport:http
  winrm set winrm/config '@{MaxTimeoutms="7200000"}'
  winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="0"}'
  winrm set winrm/config/winrs '@{MaxProcessesPerShell="0"}'
  winrm set winrm/config/winrs '@{MaxShellsPerUser="0"}'
  winrm set winrm/config/service '@{AllowUnencrypted="true"}'
  winrm set winrm/config/service/auth '@{Basic="true"}'
  winrm set winrm/config/client/auth '@{Basic="true"}'

  net stop winrm
  sc.exe config winrm start=auto
  net start winrm
}

Write-Log "BEGIN: enable_winrm.ps1"
Write-Log "Add WinRM Firewall Rules"
Add-WinRMFW
Write-Log "Enable WinRM"
Enable-WinRM
Write-Log "END: enable_winrm.ps1"
