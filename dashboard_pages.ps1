$Page1 = New-UDPage -Name "Process" -Icon adjust -Content { 



        New-UdGrid -Title "Processes" -Headers @("Name", "ID", "Working Set", "CPU", "Stoppa") -Properties @("Name", "Id", "WorkingSet", "CPU", "Stoppa") `
         -PageSize 50  -Endpoint {
       Get-Process | % {
       
       
         [psobject]@{
        Id = $_.Id
        Name = $_.ProcessName
        WorkingSet = [int]"$($_.WorkingSet / 1MB)"
        CPU = $_.CPU
        Stoppa =  New-UDButton -Text "Stop" -onclick {Stop-Process $_}

         }
       
       
       }| Out-UDGridData 
        } 



 }


 
 $Page2 = New-UDPage -Name "CPU" -Icon  address_book_o -Content { 

    New-UdMonitor -Type Line -Title "CPU" -RefreshInterval 1 -DataPointHistory 100 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
       Get-Counter '\Processor(_total)\% processortid' | Select-Object -ExpandProperty CounterSamples | Select -ExpandProperty CookedValue | Out-UDMonitorData
        }


        }




 $Page3 = New-UDPage -Name "CPU och minne" -Icon  adn -Content { 


 New-UDCard -Size medium -Endpoint {
    New-UdMonitor -Type Line -Title "CPU" -RefreshInterval 3 -DataPointHistory 100 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
       Get-Counter '\Processor(_total)\% processortid' | Select-Object -ExpandProperty CounterSamples | Select -ExpandProperty CookedValue | Out-UDMonitorData
        }

        }


 New-UDCard -Size medium -Endpoint {
    New-UDMonitor -Type Line -Title "Minne" -RefreshInterval 3 -DataPointHistory 100 -ChartBackgroundColor '#806B63' -ChartBorderColor '#F6B63'  -Endpoint {
        Get-Counter '\Minne\Tillgängliga megabyte' | Select-Object -ExpandProperty CounterSamples | Select -ExpandProperty CookedValue | Out-UDMonitorData
            }
        }


        }#end Page3




 $Page4 = New-UDPage -Name "CPU och minne 2" -Icon amazon -Content { 


New-UDRow -Columns{
 
 # Sizen är 12 av en hel rad
    New-UDColumn -SmallSize 6 -Content {
    New-UdMonitor -Type Line -Title "CPU" -RefreshInterval 30 -DataPointHistory 100 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
       Get-Counter '\Processor(_total)\% processortid' | Select-Object -ExpandProperty CounterSamples | Select -ExpandProperty CookedValue | Out-UDMonitorData
        }

        }
  
    
     
    New-UDColumn -SmallSize 6 -Content {
    New-UDMonitor -Type Line -Title "Minne" -RefreshInterval 30 -DataPointHistory 100 -ChartBackgroundColor '#806B63' -ChartBorderColor '#F6B63'  -Endpoint {
        Get-Counter '\Minne\Tillgängliga megabyte' | Select-Object -ExpandProperty CounterSamples | Select -ExpandProperty CookedValue | Out-UDMonitorData
            }
        }

    }#end row  
        }#end Page4



 $Page5 = New-UDPage -Name "CPU och minne 3" -Icon amazon -Content { 


New-UDRow -Columns{
 

  
  
          New-UDInput -Title "User Data" -Endpoint {
    param($Name)

   
       New-UDColumn -SmallSize 6 -Content {
    New-UDTable  -Title "Minne" -Headers "title"    -Endpoint {
       Write-Host $Name 
            }
        }
   }

  
    
    }#end row 
     
 
        }#end Page5



 $Page6 = New-UDPage -Name "Disk Space" -Icon amazon -Content { 
 
 New-UDRow -Columns{
        New-UDColumn -SmallSize 6 -Content {
                New-UDChart -Type Bar -Endpoint {
                    Get-CimInstance -ClassName Win32_LogicalDisk | ForEach-Object {
                        [PSCustomObject]@{ DeviceId = $_.DeviceID;
                                      UsedSize = [Math]::Round(($_.Size -$_.FreeSpace) / 1GB, 2);
                                      FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } |
                     Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
                     New-UdChartDataset -DataProperty "UsedSize" -Label "UsedSize" -BackgroundColor "#e0474c" -HoverBackgroundColor "#b11a21"
                     New-UdChartDataset -DataProperty "FreeSpace" -Label "Free Space" -BackgroundColor "#7ebc59" -HoverBackgroundColor "#7acfd6"
                 )
                    } -Labels @("Process Memory") -Options @{

                        animation = @{
                                            duration = 3000
                                            easing = "easeInBounce"
                                     }
                                     
                        scales = @{
                            xAxes = @(
                                @{
                                   
                                    stacked = $true
                                }
                            )
                            yAxes = @(
                                @{
                                     scaleLabel = @{
                                     display= $true
                                     labelString= "GB"

                                     }
                                    
                                    
                                    stacked = $true
                                    
                                }
                            )
                        }
                    }#end options
        }#End Column
  }#End Row
 
        }#end Page6


 $Page7 = New-UDPage -Name "Run Command" -Icon adjust -Content { 


         
        New-UDInput -Title "Find Fil" -Endpoint {
        param($File) 

     # Get a module from the gallery
      $Search = Get-ChildItem $File -Recurse

          New-UDInputAction -Content @(
        New-UDCard -Title "$File - $env:USERNAME" -Text $Search.fullname
    )
    }


 }


 $Page8 = New-UDPage -Name "Disk Monitor" -Icon  adn -Content { 
 
    New-UDRow -Columns{
        New-UDColumn -SmallSize 6 -Content {
          New-UDCard  -Endpoint {
                New-UDInput -Title "ComputerName" -Endpoint {
                    param($ComputerName)

                    New-UDInputAction -Content (

                     New-UdMonitor -Type Line -Title "CPU" -RefreshInterval 3 -DataPointHistory 100 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
                           Get-Counter -Counter '\Processor(_total)\% processortid' | Select-Object -ExpandProperty CounterSamples | Select -ExpandProperty CookedValue | Out-UDMonitorData
                            }
                            
                                                )#End Action

                        
                        }#New Input

                
                 }#End Card
        }#End Column

    }#End Row

  }#end Page8



 $Page9 = New-UDPage -Name "Remote Monitor" -Icon  adn -Content { 

   New-UDRow -Columns {
            New-UDColumn -Size 4 -Content {
                New-UDSelect -Label "Servers" -Option {
                    New-UDSelectOption -Name "win16sql01" -Value "win16sql01.adhypv.local"
                    New-UDSelectOption -Name "server2" -Value "server2"
                } -OnChange {
                    $Session:Character = $EventData
                    Show-UDToast -Message "Changed to $($eventdata)" -Duration 5000
                    $Session:Server = ( [string]$eventdata ).Trim( '"' )
                    Sync-UDElement -Id "dql"
                    Sync-UDElement -Id "proc"
                    Sync-UDElement -Id "disktime"
                }
            }
        }
        New-UDCard -Title "Querying $($Session:Server)" -Content {
            New-UDRow -Columns {
                New-UdColumn -Size 4 -Content {
                    New-UdMonitor -id "proc" -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
                        try {
                            Show-UDToast -Message "Should be $($Session:Server)"
                            Get-Counter -ComputerName $($Session:Server) -Counter '\Processor(_Total)\% Processor Time' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
                        }
                        catch {
                            Write-UDLog -Message "Exception $($Error[0].Exception)" -Level Error
                            50 | Out-UDMonitorData
                        }
                    }
                }
            }
        }


}#End Page9


$Page10 = New-UDPage -Name "Shit" -Icon adn -Content { 

    New-UDRow -Columns {
             New-UDColumn -Size 4 -Content {
                 New-UDSelect -Label "Servers" -Option {
                     New-UDSelectOption -Name "win16sql01" -Value "win16sql01.adhypv.local"
                     New-UDSelectOption -Name "optimusprime" -Value "optimusprime"
                     New-UDSelectOption -Name "apa" -Value "apa"
                 } -OnChange {
                     $Session:Character = $EventData
                     $cache:CC = $EventData
                     Show-UDToast -Message "$EventData" -Duration 5000
                     #$Session:Server = ( [string]$eventdata ).Trim( '"' )
                  #    Sync-UDElement -Id "proc"
                     
                 }
             }
         }
         New-UDCard -Title "Frågar $cache:CC" -Content {
             New-UDRow -Columns {
                 New-UdColumn -Size 4 -Content {
                    
                    New-UdMonitor -id "proc" -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
                        Get-Counter -Counter "\\$cache:cc\Processor(_Total)\% Processor Time"  |
                        Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
                     
                     }# end new-monitor
                    
                     New-UDButton -Text "Refresh" -BackgroundColor "#4caf50" -OnClick (New-UDEndpoint -Endpoint {
                         Show-UDToast -Message "Should be $cache:CC" -Duration 2000
                        
                        
                         Sync-UDElement -Id "proc"
                     }#End endpoint
                 )#End button
                     
                 }#end column
             }#end row
         }#End new idcard
 
 
 }#End Page10

$Page11 = New-UDPage -Name "Checklist" -Icon adjust -Content { 

  
    
    New-UDRow -Columns {
        New-UDColumn -Size 4 -Content {
            New-UDSelect -Label "Servers" -Option {
                New-UDSelectOption -Name "win16sql01" -Value "win16sql01.adhypv.local"
                New-UDSelectOption -Name "optimusprime" -Value "optimusprime"
                New-UDSelectOption -Name "apa" -Value "apa"
            } -Id Select -OnChange {
                $Session:Character = $EventData
                $cache:Server = $EventData

                $Cache:Data = @{
                    'Computer Name' = $env:COMPUTERNAME
                    'Operating System' = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
                    'Total Disk Space (C:)' = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'").Size / 1GB | ForEach-Object { "$([Math]::Round($_, 2)) GBs " }
                    'Free Disk Space (C:)' = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace / 1GB | ForEach-Object { "$([Math]::Round($_, 2)) GBs " }
                    'ServerChoice' = $cache:Server
                    'Apa' = $Cache:apa
                  }.GetEnumerator()
                  
                Show-UDToast -Message "$EventData" -Duration 3000
                Sync-UDElement -Id Table
                Sync-UDElement -Id Grid
                
            }
        }
    }

  <#  New-UDButton -Text "Sync" -Id "Button" -OnClick {
        $Session:Clicked = $true
        Sync-UDElement -Id "Table"
        Sync-UDElement -Id Grid
    }
#>
   


 <#   New-UdGrid -Title "Processes" -Headers @("Name", "ID", "Working Set", "CPU", "Stoppa", "Service") -Properties @("Name", "Id", "WorkingSet", "CPU", "Stoppa", "Service") `
     -PageSize 50  -Endpoint {
   Get-Process | % {
   
   
     [psobject]@{
    Id = $_.Id
    Name = $_.ProcessName
    WorkingSet = [int]"$($_.WorkingSet / 1MB)"
    CPU = $_.CPU
    Stoppa =  New-UDButton -Text "Stop" -onclick {Stop-Process $_}
    Service =  New-UDButton -Text "Service" -onclick {$Cache:exe = $_.ProcessName}
     }
   
   
   }| Out-UDGridData 
    } 
#>

    New-UDTable -Title "Server Information" -Headers @(" ", " ") -ArgumentList @($Cache:Data) -Endpoint {
        $Data = $Cache:Data
        $Data | Out-UDTableData -Property @("Name", "Value")

    } -Id Table

    New-UDGrid -Title "Service Status" -Headers @("Name", "Value") -Properties @("Name", "Value") -ArgumentList @($Cache:Data) -Endpoint {
        $Data = $Cache:Data
        #Send Data out
        $Data | Out-UDGridData
    } -Id Grid


   New-UDInput -Title "Find module version" -Endpoint {
    param($cache:Server,$apa) 

    # Get a module from the gallery
    
    $Cache:apa = $apa

    New-UDInputAction -Toast $cache:Server
    Sync-UDElement -Id Grid
}
}


    $MyDashboard = New-UDDashboard -Pages @($Page1, $Page2, $Page3, $Page4, $Page5, $Page6, $Page7, $Page8, $Page9) -Title "Awesome"

    $MyDashboard = New-UDDashboard -Pages @($Page11) -Title "Awesome"

        Start-UDDashboard -Port 1000 -Dashboard $MyDashboard
Get-UDDashboard

Get-UDDashboard | Stop-UDDashboard


New-UDCollection