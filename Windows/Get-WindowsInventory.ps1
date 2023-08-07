#Invetory Windows

#System

Function Get-SystemInfo {

     $Bios = Get-CimInstance -ClassName Win32_BIOS
     $Motherboard = Get-CimInstance -ClassName Win32_BaseBoard
     $System = gcim Win32_ComputerSystem 

     $SystemObj = @()
     #Hash table
     $Props = [ordered]@{
          SysName             = $System.Name
          BIOSVersion         = $Bios.SMBIOSBIOSVersion
          BiosSerialNumber    = $Bios.SerialNumber
          BiosManufacturer    = $Bios.Manufacturer
          BiosReleaseDate     = $Bios.ReleaseDate
          MBManufacturer      = $Motherboard.Manufacturer
          Processors          = $System.NumberOfProcessors
          PhysicalMemoryGB    = $System.TotalPhysicalMemory / 1gb -as [int]
          SysStatus           = $System.Status
          MBSerialNumber      = $Motherboard.SerialNumber
          MBVersion           = $Motherboard.Version
          MBProduct           = $Motherboard.Product
          MBModel             = $Motherboard.Model
          SysBootupState      = $System.BootupState
          SysDNSHostName      = $System.DNSHostName
          SysChassisSKUNumber = $System.ChassisSKUNumber
          SysDomain           = $System.Domain
          SysModel            = $System.Model
     }

     $SystemObj += New-Object -TypeName pscustomobject -Property $Props
     $SystemObj
}#Get-SystemInfo


#OS

Function Get-OSInfo {
     $OS = Get-ComputerInfo

     $OSObj = @()
     #Hash table
     $Props = [ordered]@{
          Hostname                   = $OS.CsCaption
          Domain                     = $OS.CsDomain
          WindowsProductName         = $OS.OsName
          OsVersion                  = $OS.OsVersion
          WindowsVersion             = $OS.WindowsVersion
          OsArchitecture             = $OS.OsArchitecture
          OsLanguage                 = $OS.OsLanguage
          KeyboardLayout             = $OS.KeyboardLayout
          OsStatus                   = $OS.OsStatus
          OsUptime                   = $os.OsUptime
          WindowsSystemRoot          = $OS.WindowsSystemRoot
          OsHotFixes                 = $OS.OsHotFixes
          OsInstallDate              = $OS.OsInstallDate
          OsLocalDateTime            = $os.OsLocalDateTime
          WindowsBuildLabEx          = $OS.WindowsBuildLabEx
          FQDN                       = $OS.CsDNSHostName
          DomainRole                 = $OS.CsDomainRole
          SystemFamily               = $OS.CsSystemFamily
          PowerPlatformRole          = $OS.PowerPlatformRole
          LogonServer                = $OS.LogonServer
          NetworkAdapters            = $OS.CsNetworkAdapters
          NumberOfProcessors         = $OS.CsNumberOfProcessors
          NumberOfLogicalProcessors  = $OS.CsNumberOfLogicalProcessors
          TotalPhysicalMemory        = $OS.CsTotalPhysicalMemory / 1gb -as [int]
          TimeZone                   = $OS.TimeZone
          OsNumberOfProcesses        = $OS.OsNumberOfProcesses
          OsHardwareAbstractionLayer = $OS.OsHardwareAbstractionLayer
          OsEncryptionLevel          = $OS.OsEncryptionLevel
          
     
     }
     
     $OSObj += New-Object -TypeName pscustomobject -Property $Props
     $OSObj
}#Get-OSInfo


#CPU

function Get-CPUInfo {
     $CPUs = Get-CimInstance -ClassName Win32_Processor 

     $CPUObj = @()
     foreach ($CPU in $CPUs) {
          #Hash table
          $Props = [ordered]@{
               DeviceID          = $CPU.DeviceID
               Name              = $CPU.Name
               NumberOfCores     = $CPU.NumberOfCores
               MaxClockSpeed     = $CPU.MaxClockSpeed
               CurrentClockSpeed = $CPU.CurrentClockSpeed
               LoadPercentage    = $CPU.LoadPercentage
               Status            = $CPU.Status
               LastErrorCode     = $CPU.LastErrorCode
          }
     
          $CPUObj += New-Object -TypeName pscustomobject -Property $Props
     } #end foreach
     $CPUObj
}#Get-CPUInfo


#Memory

Function Get-MemoryInfo {
     $Dimms = Get-CimInstance -ClassName Win32_PhysicalMemory 

     $MemoryObj = @()
     foreach ($Memory in $Dimms) {
          #Hash table
          $Props = [ordered]@{
               Manufacturer         = $Memory.Manufacturer
               PartNumber           = $Memory.PartNumber
               SerialNumber         = $Memory.SerialNumber
               DeviceLocator        = $Memory.DeviceLocator
               Speed                = $Memory.Speed
               ConfiguredClockSpeed = $Memory.ConfiguredClockSpeed
               SizeGB               = $Memory.TypeDetail / 1024 -as [int]
          }

          $MemoryObj += New-Object -TypeName pscustomobject -Property $Props
     } #end foreach
     $MemoryObj
}#Get-MemoryInfo

#Optimize network
#New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Psched"
#New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Psched" -Name "NonBestEffortLimit" -Type DWord -Value 0
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Type DWord -Value 0xffffffff


#Disk

function Get-DiskInfo {
     $Disks = Get-PhysicalDisk

     $DiskObj = @()
     foreach ($Disk in $Disks) {
          #Hash table
          $Props = [ordered]@{
               OperationalStatus  = $Disk.OperationalStatus
               BusType            = $Disk.BusType
               MediaType          = $Disk.MediaType
               SizeGB             = $Disk.Size / 1gb -as [int]
               Manufacturer       = $Disk.Manufacturer
               Model              = $Disk.Model
               SpindleSpeed       = $Disk.SpindleSpeed
               PhysicalLocation   = $Disk.PhysicalLocation
               LogicalSectorSize  = $Disk.LogicalSectorSize
               PhysicalSectorSize = $Disk.PhysicalSectorSize
               FirmwareVersion    = $Disk.FirmwareVersion
               SerialNumber       = $Disk.SerialNumber
          }
     
          $DiskObj += New-Object -TypeName pscustomobject -Property $Props
     } #end foreach
     $DiskObj
}#Get-DiskInfo


function Get-VolumeInfo {
     $Volumes = Get-Volume
     $VolumeObj = @()
     foreach ($Volume in $Volumes) {
          #Hash table
          $Props = [ordered]@{
               OperationalStatus  = $Volume.OperationalStatus
               DriveType          = $Volume.DriveType
               FileSystemType     = $Volume.FileSystemType
               DedupMode          = $Volume.DedupMode
               AllocationUnitSize = $Volume.AllocationUnitSize
               DriveLetter        = $Volume.DriveLetter
               FileSystemLabel    = $Volume.FileSystemLabel
               SizeGB             = $Volume.Size / 1gb -as [int]
               SizeRemainingGB    = $Volume.SizeRemaining / 1gb -as [int]
               Path               = $Volume.Path
          }
     
          $VolumeObj += New-Object -TypeName pscustomobject -Property $Props
     } #end foreach
     $VolumeObj | Sort-Object -Property DriveLetter
}#Get-VolumeInfo


function Get-PartitionInfo {
     $Partitions = Get-Partition

     $PartitionObj = @()
     foreach ($Partition in $Partitions) {
          #Hash table
          $Props = [ordered]@{
               OperationalStatus = $Partition.OperationalStatus
               Type              = $Partition.Type
               DriveLetter       = $Partition.DriveLetter
               PartitionNumber   = $Partition.PartitionNumber
               DiskNumber        = $Partition.DiskNumber
               SizeGB            = $Partition.Size / 1gb -as [int]
               IsBoot            = $Partition.IsBoot
               IsActive          = $Partition.IsActive
               IsHidden          = $Partition.IsHidden
               IsReadOnly        = $Partition.IsReadOnly
               IsShadowCopy      = $Partition.IsShadowCopy
               IsSystem          = $Partition.IsSystem
               DiskId            = $Partition.DiskId
               GptType           = $Partition.GptType
               MbrType           = $Partition.MbrType
               Offset            = $Partition.Offset
               TransitionState   = $Partition.TransitionState
     
          }
     
          $PartitionObj += New-Object -TypeName pscustomobject -Property $Props
     } #end foreach
     $PartitionObj | Sort-Object -Property DiskNumber, PartitionNumber
     
}#Get-PartitionInfo


function Get-CPUPerformance {

     $CPUPerformance = (Get-Counter "\Processor(_total)\% Processor Time" -SampleInterval 30 -MaxSamples 1).CounterSamples.CookedValue
}




#Diskperformace Guide
<#
IO Disk Transfers/sec (Disk Reads/sec, Disk Writes/sec)

Latancy Avg. Disk sec/Transfer (Avg. Disk sec/Read, Avg. Disk sec/Write) 

IO Size Avg. Disk Bytes/Transfer (Avg. Disk Bytes/Read, Avg. Disk Bytes/Write) 

Throughput Disk Bytes/sec (Disk Read Bytes/sec, Disk Write Bytes/sec) 
#>

function Get-IOPS {


     [CmdletBinding()]
     param
     (
          $Drive,

          $SampleInterval,

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
function Get-DiskPerformanceInfo {
     [CmdletBinding()]
     param
     (
          $Drive,
          $SampleInterval,
          $MaxSamples
     )
     $Obj = @()
     
     
     $Counters = "\LogicalDisk($Drive)\Disk Transfers/sec", "\LogicalDisk($Drive)\Avg. Disk sec/Transfer", "\LogicalDisk($Drive)\Disk Bytes/sec"

     $DiskPerf = Get-Counter -Counter $Counters -SampleInterval $SampleInterval -MaxSamples $MaxSamples | Select-Object -ExpandProperty CounterSamples

     $Props = [ordered]@{
          Disk         = ($DiskPerf | Where-Object path -Like "*disk transfers*").InstanceName
          IOPS         = ($DiskPerf | Where-Object path -Like "*disk transfers*").CookedValue -as [int]
          LatencyMS    = ($DiskPerf | Where-Object path -Like "*Avg*").CookedValue -as [int]
          ThroughputKB = (($DiskPerf | Where-Object path -Like "*Disk Bytes*").CookedValue / 1kb) -as [int]
          Timestamp    = $DiskPerf[0].Timestamp
     }

     $Obj += New-Object -TypeName psobject -Property $Props

     $Obj | Sort-Object -Property disk

} #End Function Get-DiskPerformanceInfo

$Drives = (Get-VolumeInfo | Where-Object DriveLetter -NE $null | Where-Object DriveType -EQ "Fixed").DriveLetter
$SampleInterval = 20
$MaxSamples = 1

Get-DiskPerformanceInfo -Drive "$($Drives):" -SampleInterval $SampleInterval -MaxSamples $MaxSamples

function Get-old {
     $Drives = (Get-VolumeInfo | Where-Object DriveLetter -NE $null | Where-Object DriveType -EQ "Fixed").DriveLetter
     $SampleInterval = 2
     $MaxSamples = 1
     
     $IOps = @()
     $Latency = @()
     $Throughput = @()
     foreach ($Drive in $Drives) {
     
          $IOps += Get-IOPS -Drive "$($Drive):" -SampleInterval $SampleInterval -MaxSamples $MaxSamples
          $Latency += Get-Latency -Drive "$($Drive):" -SampleInterval $SampleInterval -MaxSamples $MaxSamples
          $Throughput += Get-DiskPerformance -Drive "$($Drive):" -SampleInterval $SampleInterval -MaxSamples $MaxSamples
     }#End Drives


     
}#Get-DiskPerformanceInfo








Get-SystemInfo | Format-Table
Get-OSInfo | Format-Table
Get-CPUInfo | Format-Table
Get-MemoryInfo | Format-Table
Get-DiskInfo | Format-Table
Get-VolumeInfo | Format-Table
Get-PartitionInfo | Format-Table

$RPSystem = Get-SystemInfo | ConvertTo-Html -As List -Fragment -PreContent "<h2>System Information</h2>"
$RPOS = Get-OSInfo | ConvertTo-Html -As List -Fragment -PreContent "<h2>OS Information</h2>"
$RPCPU = Get-CPUInfo | ConvertTo-Html -As List -Fragment -PreContent "<h2>Processor Information</h2>"
$RPMemory = Get-MemoryInfo | ConvertTo-Html -As List -Fragment -PreContent "<h2>Memory Information</h2>"
$RPDisk = Get-DiskInfo | ConvertTo-Html -As Table -Fragment -PreContent "<h2>Disk Information</h2>"
$RPVolume = Get-VolumeInfo | ConvertTo-Html -As Table -Fragment -PreContent "<h2>Volume Information</h2>"
$RPPartition = Get-PartitionInfo | ConvertTo-Html -As Table -Fragment -PreContent "<h2>Partition Information</h2>"



$css = @"
<style>
h1 {

     font-family: Arial, Helvetica, sans-serif;
     color: #e68a00;
     font-size: 28px;

 }

 
 h2 {

     font-family: Arial, Helvetica, sans-serif;
     color: #000099;
     font-size: 16px;

 }

 
 
table {
       font-size: 12px;
       border: 0px; 
       font-family: Arial, Helvetica, sans-serif;
  } 
  
 td {
       padding: 4px;
       margin: 0px;
       border: 0;
  }
  
 th {
     background: #395870;
     background: linear-gradient(#49708f, #293f50);
     color: #fff;
     font-size: 11px;
     text-transform: uppercase;
     padding: 10px 15px;
     vertical-align: middle;
  }

 tbody tr:nth-child(even) {
     background: #f0f0f2;
 }

     #CreationDate {

     font-family: Arial, Helvetica, sans-serif;
     color: #ff3300;
     font-size: 12px;

 }
</style>
"@

<#
$css = @"
<style>


</style>
"@
#>

$Report = ConvertTo-Html -Body "$RPSystem $RPOS $RPCPU $RPMemory $RPDisk $RPVolume $RPPartition" `
     -Title "Computer Information" -Head $css -PostContent "<p>Creation Date: $(Get-Date)<p>"


$Report | Out-File -FilePath .\report.html