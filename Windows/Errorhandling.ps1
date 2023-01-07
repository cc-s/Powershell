
#$Error[0].Exception.GetType().FullName
# Get-Error
try {
     New-Item -Path .\ -Name Test.tst -ItemType File -Value "abc" -ErrorAction Stop
     New-Item -Path .\ -Name "jhj|.tst" -ItemType File -Value "abc" -ErrorAction Stop
}
catch [System.IO.DirectoryNotFoundException]{
     Write-warning "$($_.exception.Message)"
}
catch [System.Management.Automation.RuntimeException]{
     if ($($_.Exception) -is [System.IO.IOException]) {
     Write-warning "$($_.exception.Message)"
     }
}
catch{
     Write-error "Default error: $($_.exception.Message)"
}