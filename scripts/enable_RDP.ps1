filter timestamp {"$(Get-Date -Format G): $_"}
$build_log = "C:\Build_Logs\build.log"

function Write-Log($msg) {
      Write-Output $msg | timestamp | Tee-Object -FilePath $build_log -append
}

function Add-RDPFW {
  netsh advfirewall firewall set rule group="remote administration" new enable=yes
  netsh advfirewall firewall add rule name="RDP Access" dir=in action=allow protocol=TCP localport=3389
}

function Enable-RDP {
  $reg_path = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
  $reg_name = "fDenyTSConnections"
  New-ItemProperty -Path $reg_path -Name $reg_name -PropertyType DWORD -Value 0 -Force
}

Write-Log "BEGIN: enable_RDP.ps1"
Write-Log "Adding RDP Firewall Rules"
Add-RDPFW
Write-Log "Enabling RDP"
Enable-RDP
Write-Log "END: enable_RDP.ps1"
