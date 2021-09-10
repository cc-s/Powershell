#Create-files
function New-Files {
     <#
.Synopsis
   Creates files based on requested size
.DESCRIPTION
   Long description
.EXAMPLE
   
.EXAMPLE
   
.EXAMPLE
 
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
     [CmdletBinding(DefaultParameterSetName = 'File')]
     [Alias()]
     Param
     (
          # File Size with unit
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 0,
               ParameterSetName = 'File')]
          $FileSize,
          
          # Number of files to create
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 1,
               ParameterSetName = 'File')]
          [int]$NumberOfFiles,

          # Directory path to where the files will be created
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 2,
               ParameterSetName = 'File')]
          [ValidateScript( {
                    if ( -Not ($_ | Test-Path) ) {
                         throw "Folder does not exist"
                    }
                    return $true
               })]
          [System.IO.FileInfo]$Path 
     )

     Begin {
          $i = 0
     }
     Process {
          while ($i -lt $NumberOfFiles) {
               $ByteObj = New-Object -TypeName Byte[] -ArgumentList ($FileSize / 4.58 )
               $RandomObj = New-Object -TypeName System.Random 
               $RandomObj.NextBytes($ByteObj)

               Set-Content -Path "$path\testfiles$i" -Value $ByteObj -Encoding utf8
               $i++
               
          }#end while
     }#end process
     End {}

}#End functions New-Files



New-Files -Path "F:\Test" -FileSize 4kb -NumberOfFiles 100000 