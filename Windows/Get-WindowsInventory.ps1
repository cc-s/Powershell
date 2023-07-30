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
          Manufacturer = $Memory.Manufacturer
          PartNumber = $Memory.PartNumber
          SerialNumber = $Memory.SerialNumber
          DeviceLocator = $Memory.DeviceLocator
          Speed = $Memory.Speed
          ConfiguredClockSpeed = $Memory.ConfiguredClockSpeed
          SizeGB = $Memory.TypeDetail /1024 -as [int]
     }

     $MemoryObj += New-Object -TypeName pscustomobject -Property $Props
} #end foreach

#Disk

