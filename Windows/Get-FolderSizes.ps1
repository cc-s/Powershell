


#Dir depth

dir -Depth 3 -directory .\a1

$Depth = 4
$Path = '.\a1'

$Levels = '/*' * $Depth
Get-ChildItem -Directory $Path/$Levels |
  ForEach-Object { ($_.FullName -split '[\\/]')[-$Depth] } |
    Select-Object -Unique


    Get-ChildItem -force 'C:\Users'-ErrorAction SilentlyContinue | Where-Object { $_ -is [io.directoryinfo] } | ForEach-Object {
     $len = 0
     Get-ChildItem -recurse -force $_.fullname -ErrorAction SilentlyContinue | ForEach-Object { $len += $_.length }
     $_.fullname, '{0:N2} GB' -f ($len / 1Gb)
     }


     $Path = 'C:\Users\Carl C\AppData\Roaming\Microsoft\Windows'
     $dataColl = @()

     Get-ChildItem -force $Path -ErrorAction SilentlyContinue | Where-Object { $_ -is [io.directoryinfo] } | ForEach-Object {
     
     $ObjectPath = $_.FullName
     $FileSize = (Get-ChildItem -recurse -force $_.FullName -ErrorAction SilentlyContinue | Measure-Object -Property length -Sum)
     $Dirs = (Get-ChildItem -recurse -Directory -force $_.FullName -ErrorAction SilentlyContinue | Measure-Object )

     $Obj = New-Object PSObject
     Add-Member -inputObject $Obj -memberType NoteProperty -name "FolderName" -value $ObjectPath
     Add-Member -inputObject $Obj -memberType NoteProperty -name "FolderSizeMB" -value ('{0:N2}' -f ($FileSize.Sum /1MB))
     Add-Member -inputObject $Obj -memberType NoteProperty -name "NumberOfFiles" -value ($FileSize.count)
     Add-Member -inputObject $Obj -memberType NoteProperty -name "NumberOfDirectories" -value ($Dirs.count)
     $dataColl += $Obj
          }
          $dataColl | sort FolderSizeMB 


$targetfolder='C:\'
$dataColl = @()
gci -force $targetfolder -ErrorAction SilentlyContinue | ? { $_ -is [io.directoryinfo] } | % {
$len = 0
gci -recurse -force $_.fullname -ErrorAction SilentlyContinue | % { $len += $_.length }
$foldername = $_.fullname
$foldersize= '{0:N2}' -f ($len / 1Gb)
$dataObject = New-Object PSObject
Add-Member -inputObject $dataObject -memberType NoteProperty -name “foldername” -value $foldername
Add-Member -inputObject $dataObject -memberType NoteProperty -name “foldersizeGb” -value $foldersize
$dataColl += $dataObject
}
$dataColl | Out-GridView -Title “Size of subdirectories”