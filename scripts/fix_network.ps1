# You cannot enable Windows PowerShell Remoting on network connections that are set to Public
# Spin through all the network locations and if they are set to Public, set them to Private
# using the INetwork interface:
# http://msdn.microsoft.com/en-us/library/windows/desktop/aa370750(v=vs.85).aspx
# For more info, see:
# http://blogs.msdn.com/b/powershell/archive/2009/04/03/setting-network-location-to-private.aspx

# You cannot change the network location if you are joined to a domain, so abort
if(1,3,4,5 -contains (Get-WmiObject win32_computersystem).DomainRole) { return }

filter timestamp {"$(Get-Date -Format G): $_"}
$build_log = "C:\Build_Logs\build.log"


function Write-Log($msg) {
    Write-Output $msg | timestamp | Tee-Object -FilePath $build_log -append
}


function Fix-Network {
  # Get network connections
  $networkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
  $connections = $networkListManager.GetNetworkConnections()
  Write-Log "Setting Network Config"
  $connections |foreach {
    $_.GetNetwork().SetCategory(1)
    Write-Log "$($_.GetNetwork().GetName()) changed to category $($_.GetNetwork().GetCategory())"
  }
}

Write-Log "BEGIN: fix_network.ps1"
Fix-Network
Write-Log "END: fix_network.ps1"
