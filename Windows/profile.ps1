#Powershell 7 Profile
#Enable-ExperimentalFeature PSAnsiRenderingFileInfo
#$PSStyle.Reset
$PSStyle.FileInfo.Extension.item(".ps1") = "`e[38;5;69m"
$PSStyle.FileInfo.extension.add(".txt", "`e[33;1m")
$PSStyle.FileInfo.extension.add(".log", "`e[33;1m")
$PSStyle.FileInfo.extension.add(".csv", "`e[95m")
$PSStyle.FileInfo.extension.add(".xml", "`e[95m")
$PSStyle.FileInfo.extension.add(".json", "`e[95m")

function Profile { code $PROFILE.CurrentUserAllHosts }
Set-PSReadLineKeyHandler -Key ? -Function MenuComplete