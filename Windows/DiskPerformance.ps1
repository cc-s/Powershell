


#Diskperformace Guide
<##>
IO Disk Transfers/sec (Get-Disk Reads/sec, Disk Writes/sec)

Latancy Avg. Disk sec/Transfer (Avg. Disk sec/Read, Avg. Disk sec/Write) 

IO Size Avg. Disk Bytes/Transfer (Avg. Disk Bytes/Read, Avg. Disk Bytes/Write) 

Throughput Disk Bytes/sec (Get-Disk Read Bytes/sec, Disk Write Bytes/sec) 
#>

#List  counters
Get-Counter -ListSet * | Select-Object -ExpandProperty paths | Select-String -Pattern 'Logisk' 


function Get-IOPS {
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true, 
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true, 
      ValueFromRemainingArguments = $false, 
      Position = 0,
      ParameterSetName = 'Param set 1')]
    [string]
    $Drive,

    [Parameter(Mandatory = $true, 
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true, 
      ValueFromRemainingArguments = $false, 
      Position = 1,
      ParameterSetName = 'Param set 1')]
    [int]
    $SampleInterval,

    [Parameter(Mandatory = $true, 
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true, 
      ValueFromRemainingArguments = $false, 
      Position = 2,
      ParameterSetName = 'Param set 1')]
    [int]
    $MaxSamples
  )
  $Obj = @()
  #Swedish
  #$IOs = Get-Counter -Counter "\Logisk disk($Drive)\Disköverföringar/s" -SampleInterval $SampleInterval -MaxSamples $MaxSamples | select -ExpandProperty CounterSamples
  
  $IOs = Get-Counter -Counter "\LogicalDisk($Drive)\Disk Transfers/sec" -SampleInterval $SampleInterval -MaxSamples $MaxSamples | Select-Object -ExpandProperty CounterSamples
  
  foreach ($value in $IOs) {

    $Props = [ordered]@{
      Disk      = $value.InstanceName
      IOPS      = $value.CookedValue -as [int]
      Timestamp = $value.Timestamp

    }

    $Obj += New-Object -TypeName psobject -Property $Props
  }

  $Obj | Sort-Object -Property disk

} #End Function IOPS

Get-IOPS -Drive C: -SampleInterval 5 -MaxSamples 2

function Get-Latency {


  [CmdletBinding()]
  param
  (
    $Drive,

    $SampleInterval,

    $MaxSamples
  )
  $Obj = @()
  #Swedish
  #$Counters = Get-Counter -Counter "\Logisk disk($Drive)\Medel s/disköverföring" -SampleInterval $SampleInterval -MaxSamples $MaxSamples | select -ExpandProperty CounterSamples

  $Counters = Get-Counter -Counter "\LogicalDisk($Drive)\Avg. Disk sec/Transfer" -SampleInterval $SampleInterval -MaxSamples $MaxSamples | Select-Object -ExpandProperty CounterSamples

  foreach ($value in $Counters) {

    $Props = [ordered]@{
      Disk      = $value.InstanceName
      Latency   = $value.CookedValue -as [int]
      Timestamp = $value.Timestamp

    }

    $Obj += New-Object -TypeName psobject -Property $Props
  }

  $Obj | Sort-Object disk

} #End Function Latency

function Get-DiskPerformance {

  [CmdletBinding()]
  param
  (
    $Drive,

    $SampleInterval,

    $MaxSamples
  )
  
  $Obj = @()
  #Swedish
  #$Counters = Get-Counter -Counter "\Logisk disk($Drive)\Medel s/disköverföring" -SampleInterval $SampleInterval -MaxSamples $MaxSamples | select -ExpandProperty CounterSamples

  $Counters = Get-Counter -Counter "\LogicalDisk($Drive)\Disk Bytes/sec" -SampleInterval $SampleInterval -MaxSamples $MaxSamples | Select-Object -ExpandProperty CounterSamples

  foreach ($value in $Counters) {

    $Props = [ordered]@{
      Disk       = $value.InstanceName
      Throughput = $value.CookedValue -as [int]
      Timestamp  = $value.Timestamp
    }

    $Obj += New-Object -TypeName psobject -Property $Props
  }

  $Obj | Sort-Object disk

} #End Function DiskPerformance


#IO

$Drive = 'C:'
$SampleInterval = 2
$MaxSamples = 2

$IOps = Get-IOPS -Drive $Drive -SampleInterval $SampleInterval -MaxSamples $MaxSamples
$Latency = Get-Latency -Drive $Drive -SampleInterval $SampleInterval -MaxSamples $MaxSamples
$Throughput = Get-DiskPerformance -Drive $Drive -SampleInterval $SampleInterval -MaxSamples $MaxSamples

