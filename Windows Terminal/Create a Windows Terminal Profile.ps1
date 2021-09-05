#Create a Windows Terminal Profile


Function Get-WTProfiles {
     $WTSettingsPath = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
     $WTSettings = Get-Content $WTSettingsPath -raw | ConvertFrom-Json
     $WTSettings.profiles.list

}#Get-WTProfiles

function Add-WTProfile {
     [CmdletBinding(DefaultParameterSetName = 'Set1')]
     [Alias()]
     Param
     (
          # Name of the profile
          [Parameter(Mandatory = $true,
               ValueFromPipeline = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 0)]
          $Name,

          # Commandline settings
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 1,
               ParameterSetName = 'Set1')]
          $Commandline,
          
          # Icon path
          [Parameter(Mandatory = $false,
               ValueFromPipelineByPropertyName = $true,
               Position = 2,
               ParameterSetName = 'Set1')]
          $Icon
     )

     $WTSettingsPath = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
     $WTSettings = Get-Content $WTSettingsPath -raw | ConvertFrom-Json
     $Icon

     #$Name = "Auto Added Profile"
     #$Commandline = 'wt.exe --tabColor #009999 ; split-pane  -p "Windows PowerShell" -c ssh root@ironhide ; split-pane -p "Command Prompt" -H -c ssh root@192.168.9.1'


     $Props = @{
          guid        = "{$(new-guid)}"
          hidden      = $false
          name        = $Name
          icon        = $Icon
          commandline = $Commandline
     }

     $Obj = New-Object -TypeName pscustomobject -Property $Props

     $WTSettings.profiles.list += $Obj

     $WTSettings | Convertto-Json -Depth 32 | Out-File -FilePath $WTSettingsPath

}#End Add-WTProfile

#Remove profile

Function Remove-WTProfile ($Name){
     $WTSettingsPath = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
     $WTSettings = Get-Content $WTSettingsPath -raw | ConvertFrom-Json
     $WTSettings.profiles.list = $WTSettings.profiles.list | ? name -notlike "$Name"
     $WTSettings | Convertto-Json -Depth 32 | Out-File -FilePath $WTSettingsPath

}#Remove-WTProfile

$WTSettings.profiles.list = $WTSettings.profiles.list | ? name -notlike "cc-test"

$WTSettings | Convertto-Json -Depth 32 | Out-File -FilePath $WTSettingsPath

#Alt
[System.Collections.ArrayList]$data = $WTSettings.profiles.list

$data.Remove(name=ja hej hej)

$data -contains "ja hej hej"


