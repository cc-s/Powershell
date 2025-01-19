#Resolve DNS names

<#
.Synopsis
   Resolves DNS names
.DESCRIPTION
   Long description
.EXAMPLE
Get-DNSNames -ip $ips
.EXAMPLE
Get-DNSNames -Filpath C:\Temp\ips.txt
.EXAMPLE
Get-Content C:\Temp\ips.txt | Get-DNSNames
.INPUTS
   List of IPs from an array of file
.OUTPUTS
   FQDN and IP
.NOTES
   Retrives DNS nams from IPs
.ROLE
   Network
.FUNCTIONALITY
Requires Powershell 6<
#>
function Get-DNSName {
     [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1', 
          SupportsShouldProcess = $true, 
          PositionalBinding = $false,
          HelpUri = 'http://github.com/cc-s/Powershell//',
          ConfirmImpact = 'Medium')]
     [Alias()]
     Param
     (
          # Path to file with IPs
          [Parameter(Mandatory = $true, 
               ValueFromPipeline = $false,
               ValueFromPipelineByPropertyName = $true, 
               ValueFromRemainingArguments = $false, 
               Position = 0,
               ParameterSetName = 'Param Set File')]
          [ValidateScript({ $_ -match "\d" }, 
               ErrorMessage = "{0} is invalid. Only IPs are valid.")]
          [Alias("path")] 
          $Filpath,

          # IP array
          [Parameter(
               Mandatory = $true,
               ValueFromPipeline = $true,
               ValueFromPipelineByPropertyName = $true, 
               ValueFromRemainingArguments = $false, 
               Position = 1,
               ParameterSetName = 'Param Set Array')]
          [AllowNull()]
          [AllowEmptyCollection()]
          [AllowEmptyString()]
          [ValidateScript({ $_ -match "\d" })]
          [Alias("ipaddress", "ip-address", "ips")]
          [string[]]
          $IP,

          # Param3 help description
          [String]
          $Param3
     )

     Begin {
          $Obj = New-Object -TypeName System.Collections.Generic.List[PSObject]
     }
     Process {

          If ($Filpath) {
               $IPAddresses = Get-Content $Filpath
          }
          elseif ($IP) {
               $IPAddresses = $IP
          }

          foreach ($address in $IPAddresses) {

               try {
                    $FQDN = Resolve-DnsName -Name $address -ErrorAction Stop
               }
               catch {
                    $FQDN = ((($PSItem.Exception -split ":")[2] -split "`r")[0]).trim()
               }
              

               $Props = [Ordered]@{
                    Hostname = if ($FQDN.server -eq $null) { $FQDN }Else { $FQDN.server }
                    IP       = $address

               }
               $Obj.Add([PSCustomObject]$Props)
          }#End foreach
     }
     End {
          $Obj
     }
}



