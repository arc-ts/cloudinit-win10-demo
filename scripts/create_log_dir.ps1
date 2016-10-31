filter timestamp {"$(Get-Date -Format G): $_"}
Write-Host 'Creating Build Log Directory' | timestamp
New-Item C:\Build_Logs -Type Directory
