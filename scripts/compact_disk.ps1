# NOTE regarding sdelete
# sdelete v2 (current release) has several issues:
#  - http://forum.sysinternals.com/sdelete-hangs-at-100_topic32267.html
# As there is no easily downloadable repository containing previous releases, version 1.61 is
# included directly.


filter timestamp {"$(Get-Date -Format G): $_"}
$build_log = "C:\Build_logs\build.log"

function Write-Log($msg) {
      Write-Output $msg | timestamp | Tee-Object -FilePath $build_log -append
}

function Install-Sdelete { 
  $reg_path = "HKCU:\Software\Sysinternals\SDelete"
  $reg_name = "EulaAccepted"
  Copy-Item "A:\sdelete.exe" "C:\Windows\Temp"
  New-Item -Path $reg_path -Force
  New-ItemProperty -Path $reg_path -Name $reg_name -PropertyType DWORD -Value 1 -Force
}
function Remove-Sdelete { Remove-Item "C:\Windows\Temp\sdelete.exe" }
function Purge-SoftwareUpdates {
  Stop-Service  wuauserv
  Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -recurse
  Start-Service wuauserv
}
function Defrag-Disk { defrag /c /x /h }
function Zero-Disk { C:\Windows\Temp\sdelete -q -z C: }

Write-Log "BEGIN: compact_disk.ps1"
Write-Log "Installing sdelete"
Install-Sdelete
Write-Log "Purging Windows Updates"
Purge-SoftwareUpdates
Write-Log "Defragging Disk"
Defrag-Disk
Write-Log "Zeroing Disk"
Zero-Disk
Write-Log "Removing sdelete"
Remove-Sdelete
Write-Log "END: compact_disk.ps1"

