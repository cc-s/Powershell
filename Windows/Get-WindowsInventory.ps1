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


#$CPUPerformance = (Get-Counter "\Processor(_total)\% Processor Time" -SampleInterval 30 -MaxSamples 1).CounterSamples.CookedValue

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

Get-SystemInfo | Format-Table
Get-OSInfo | Format-Table
Get-CPUInfo | Format-Table
Get-MemoryInfo | Format-Table
Get-DiskInfo | Format-Table
Get-VolumeInfo | Format-Table
Get-PartitionInfo | Format-Table