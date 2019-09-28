<#
.SYNOPSIS
    Extract handle info using sysinternals handle.exe
.DESCRIPTION
     Creates an object containing Process, Type, Pid and Path
.EXAMPLE
     Get-handle -Process firefox 
     Retreives all handes for Firefox
.INPUTS
  ExePath = Folderpath to handle64.exe ex: C:\SysinternalsSuite\handle64.exe
  Process = Process to check
.OUTPUTS
     PSobject
.NOTES
     General notes
#>

function Get-Handle($Process,$ExePath){

     if ($ExePath -notlike "*handle*"){
          Write-Error -Message "Proved correct path to handle64.exe"
          break
     }

     $Data = & $ExePath $process -nobanner

     $FormatedData = $Data | ConvertFrom-String -PropertyNames "Process","a","Pid","b","Type","c","Path","x","y"

     $FormatedData | Select-Object Process,Type,Pid,@{n="path";e={$_.Path + $_.x + $_.y}}


}

Get-handle -process firefox 