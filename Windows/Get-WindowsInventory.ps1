#Invetory Windows

#System

$Bios = Get-CimInstance -ClassName Win32_BIOS
$Motherboard = Get-CimInstance -ClassName Win32_BaseBoard
$System = gcim Win32_ComputerSystem 




$SystemObj = @()
#Hash table
$Props = [ordered]@{
     SMBIOSBIOSVersion      = $Bios.SMBIOSBIOSVersion
     BiosSerialNumber       = $Bios.SerialNumber
     BiosManufacturer       = $Bios.Manufacturer
     BiosReleaseDate        = $Bios.ReleaseDate
     MBManufacturer         = $Motherboard.Manufacturer
     MBSerialNumber         = $Motherboard.SerialNumber
     MBVersion              = $Motherboard.Version
     MBProduct              = $Motherboard.Product
     MBModel                = $Motherboard.Model
     SysBootupState         = $System.BootupState
     SysStatus              = $System.Status
     SysName                = $System.Name
     SysDNSHostName         = $System.DNSHostName
     SysChassisSKUNumber    = $System.ChassisSKUNumber
     SysDomain              = $System.Domain
     SysModel               = $System.Model
     SysNumberOfProcessors  = $System.NumberOfProcessors
     SysTotalPhysicalMemory = $System.TotalPhysicalMemory

}

$SystemObj += New-Object -TypeName pscustomobject -Property $Props

#OS
$OS = Get-ComputerInfo

$OSObj = @()
#Hash table
$Props = [ordered]@{
     WindowsProductName        = $OS.OsName
     WindowsSystemRoot         = $OS.WindowsSystemRoot
     WindowsVersion            = $OS.WindowsVersion
     OSDisplayVersion          = $OS.OSDisplayVersion
     WindowsBuildLabEx         = $OS.WindowsBuildLabEx
     OsVersion                 = $OS.OsVersion
     OsHotFixes                = $OS.OsHotFixes
     OsInstallDate             = $OS.OsInstallDate
     OsArchitecture            = $OS.OsArchitecture
     OsLanguage                = $OS.OsLanguage
     Hostname                  = $OS.CsCaption
     FQDN                      = $OS.CsDNSHostName
     Domain                    = $OS.CsDomain
     DomainRole                = $OS.CsDomainRole
     SystemFamily              = $OS.CsSystemFamily
     LogonServer               = $OS.LogonServer
     NetworkAdapters           = $OS.CsNetworkAdapters
     NumberOfProcessors        = $OS.CsNumberOfProcessors
     NumberOfLogicalProcessors = $OS.CsNumberOfLogicalProcessors
     TotalPhysicalMemory       = $OS.CsTotalPhysicalMemory
     TimeZone                  = $OS.TimeZone

}

$OSObj += New-Object -TypeName pscustomobject -Property $Props


#CPU
$CPUs = Get-CimInstance -ClassName Win32_Processor 

$CPUObj = @()

foreach ($CPU in $CPUs) {
     #Hash table
     $Props = [ordered]@{
          DeviceID          = $CPU.DeviceID
          Name              = $CPU.Name
          LastErrorCode     = $CPU.LastErrorCode
          LoadPercentage    = $CPU.LoadPercentage
          CurrentClockSpeed = $CPU.CurrentClockSpeed
          MaxClockSpeed     = $CPU.MaxClockSpeed
          Status            = $CPU.Status
          NumberOfCores     = $CPU.NumberOfCores
     }

     $CPUObj += New-Object -TypeName pscustomobject -Property $Props
} #end foreach

$CPUPerformance = (Get-Counter "\Processor(_total)\% Processor Time" -SampleInterval 30 -MaxSamples 1).CounterSamples.CookedValue

#Memory


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


#Optimize network
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Psched"
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Psched" -Name "NonBestEffortLimit" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Type DWord -Value 0xffffffff



#Rebuild


#Disk

$Disks = Get-PhysicalDisk
$Volumes = Get-Volume
$Partitions = Get-Partition

$DiskObj = @()
foreach ($Disk in $Disks) {
     #Hash table
     $Props = [ordered]@{
          OperationalStatus  = $Disk.OperationalStatus
          BusType            = $Disk.BusType
          MediaType          = $Disk.MediaType
          SpindleSpeed       = $Disk.SpindleSpeed
          Manufacturer       = $Disk.Manufacturer
          Model              = $Disk.Model
          PhysicalLocation   = $Disk.PhysicalLocation
          LogicalSectorSize  = $Disk.LogicalSectorSize
          PhysicalSectorSize = $Disk.PhysicalSectorSize
          FirmwareVersion    = $Disk.FirmwareVersion
          SizeGB             = $Disk.Size / 1gb -as [int]
          SerialNumber       = $Disk.SerialNumber
     }

     $DiskObj += New-Object -TypeName pscustomobject -Property $Props
} #end foreach

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
$PartitionObj | Sort-Object -Property DiskNumber, PartitionNumber| Format-Table