filter timestamp {"$(Get-Date -Format G): $_"}
$build_log = "C:\Build_Logs\build.log"

function Write-Log($msg) {
      Write-Output $msg | timestamp | Tee-Object -FilePath $build_log -append
}

function Enable-Sysprep {
  $reg_path = "HKLM:\SYSTEM\Setup\Status\SysprepStatus"
  $reg_name = "GeneralizationState"
  New-ItemProperty -Path $reg_path -Name $reg_name -PropertyType DWORD -Value 7 -Force
}

Write-Log "BEGIN: enable_sysprep.ps1"
Write-Log "Setting Sysprep status to 7"
Enable-Sysprep
Write-Log "END: enable_sysprep.ps1"
