

#Performance psobject

$Maxitems = 10000
$MeasuredTimes = 100
$MeasuredData = [System.Collections.Generic.List[PSObject]]::new()

for ($m = 1; $m -le $MeasuredTimes; $m++) {


     # Array based

     $A = Measure-Command {

          $Obj = @()
          for ($i = 0; $i -lt $Maxitems; $i++) {
     
               #Hash table
               $Props = [ordered]@{
                    ID                   = $i
                    CmdletGeneratedValue = Get-Random -Minimum 0 -Maximum 10000
                    Static               = "String"

               }

               $Obj += New-Object -TypeName pscustomobject -Property $Props
          } #end for

     }#end measure


     # List based New-Object

     $L1 = Measure-Command {

          $Obj = New-Object -TypeName System.Collections.Generic.List[PSObject]

          for ($i = 0; $i -lt $Maxitems; $i++) {
     
               #Hash table
               $Props = [ordered]@{
                    ID                   = $i
                    CmdletGeneratedValue = Get-Random -Minimum 0 -Maximum 10000
                    Static               = "String"

               }

               $Obj.Add([PSCustomObject]$Props)
          } #end for

     }#end measure


     # List based .Net loaded syntax
     $L2 = Measure-Command {

          $Obj = [System.Collections.Generic.List[PSObject]]::new()
          for ($i = 0; $i -lt $Maxitems; $i++) {
     
               #Hash table
               $Props = [ordered]@{
                    ID                   = $i
                    CmdletGeneratedValue = Get-Random -Minimum 0 -Maximum 10000
                    Static               = "String"

               }

               $Obj.Add([PSCustomObject]$Props)
          } #end for

     } #end measure 

     $MeasuredProps = [Ordered]@{
          Iteration       = $m
          Tests           = $MeasuredTimes
          ArrayBased      = $A.TotalSeconds
          List_New_Object = $L1.TotalSeconds
          List_dotNet     = $L2.TotalSeconds
     }

     $MeasuredData.Add([PSCustomObject]$MeasuredProps)

}#Measure for


$MeasuredData | Format-Table

$MeasuredData | Measure-Object -Property ArrayBased, List_New_Object, List_dotNet -Average | Select-Object Property, Average
