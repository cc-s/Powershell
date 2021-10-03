#Package trace


Function Start-NetTrace {
     <#
.Synopsis
   Compares a set of SHA265 hashes to one or more files.
.DESCRIPTION
   Long description
.EXAMPLE
   Compare-FileHashes -Hashlist "9190F005ADCC59F1D2CFF21B8D4FBBA70D72B8B4B567D845B33508A9C388A7A2", "E83D5041B91BC337092E5BA54DFFD9B90AF2DA3ACA365D700458059B7F5C184E" -Files "E:\Users\Carl C\Downloads\PowerShell-7.1.4-win-x64.msi","E:\Users\Carl C\Downloads\mumble-1.2.4.msi"
.EXAMPLE
   "9190F005ADCC59F1D2CFF21B8D4FBBA70D72B8B4B567D845B33508A9C388A7A2", "E83D5041B91BC337092E5BA54DFFD9B90AF2DA3ACA365D700458059B7F5C184E" | Compare-FileHashes -Files "E:\Users\Carl C\Downloads\PowerShell-7.1.4-win-x64.msi","E:\Users\Carl C\Downloads\mumble-1.2.4.msi"
.EXAMPLE
 $a = [PSCustomObject]@{"Hashlist"="9190F005ADCC59F1D2CFF21B8D4FBBA70D72B8B4B567D845B33508A9C388A7A2", "E83D5041B91BC337092E5BA54DFFD9B90AF2DA3ACA365D700458059B7F5C184E"; "Files"="E:\Users\Carl C\Downloads\PowerShell-7.1.4-win-x64.msi","E:\Users\Carl C\Downloads\mumble-1.2.4.msi"}
 $a | Compare-FileHashes
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
     [CmdletBinding(DefaultParameterSetName = 'Default')]
     [Alias()]
     Param
     (
          # File paths
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 0,
               ParameterSetName = 'Default')]
          [ValidateSet("True", "False")]
          $Truncate,
     
          # Directory path to where the log file will be created
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 1,
               ParameterSetName = 'Default')]
          [ValidateScript( {
                    if ( -Not ($_ | Test-Path) ) {
                         throw "Folder does not exist"
                    }
                    return $true
               })]
          [System.IO.FileInfo]$Path,
          $MaxSize = "200",
          $Filemode = "circular"
     )

     if ($Truncate -eq $true) {
          $packettruncatebytes = "packettruncatebytes=1024"
          Write-Host $packettruncatebytes
     }#End if Truncate

     netsh trace start capture=yes $packettruncatebytes tracefile="$Path\nettrace.etl" maxsize=$MaxSize filemode=$Filemode overwrite=yes report=disabled

     #ipv4.address=(65.216.148.229,18.211.196.51)


}#End Start-NetTrace 


Start-NetTrace -Truncate $false -Path "C:\Temp"

Function Stop-NetTrace {
     netsh trace stop
}#End Stop-NetTrace

Stop-NetTrace


Function ConvertETL2To-PCAP {
     [CmdletBinding(DefaultParameterSetName = 'Default')]
     [Alias()]
     param(
          $etl2In,
          $pcapOut,
          $etl2pcapngPath
     )

     if ($etl2pcapngPath -eq $null) {

          $etl2pcapngPath = "C:\Verktyg\etl2pcapng\etl2pcapng.exe"
     }#End if etl2
     if ( -Not ($etl2pcapngPath | Test-Path) ) {
          throw "Folder does not exist"
     }
     & $etl2pcapngPath "$etl2Path" "$pcapngPath"


}#End ConvertTo-PCAP

ConvertETL2To-PCAP -etl2In C:\Temp\nettrace.etl -pcapOut C:\temp\nettrace.pcapng