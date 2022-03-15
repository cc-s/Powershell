#Netbox Rest   

Add-Type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy


$TokenBody = @{
     username = "admin"
     password = "abc123"

}

$TokenHeader = @{
     'Content-Type' = "application/json"
     Accept         = "application/json"
}

$token = (Invoke-RestMethod -Method post -Uri "https://netbox/api/users/tokens/provision/" -Body ($TokenBody | ConvertTo-JsonEx) -Headers $TokenHeader).key



$SitesUri = "https://netbox/api/dcim/sites/"
$DeviceUri = "https://netbox/api/dcim/devices/"
$InterfaceUri = "https://netbox/api/dcim/interfaces/"
$CableUri = "https://netbox/api/dcim/cables/"


$headers = @{
     'Authorization' = "Token $TOKEN"
     'Accept'        = 'application/json'
     'Content-Type'  = "application/json"
}

$Form = @{
     name   = 'port1/2'
     type   = '1000base-t'
     device = @{id = 2; url = 'https://netbox/api/dcim/devices/2/'; display = 'switch1'; name = 'switch1' }
}


$Form = @{
     name        = 'port1/3'
     type        = '1000base-t'
     device      = @{ name = 'switch1' }
     description = "jahej"
}

$SitesRequest = Invoke-RestMethod -Method get -Uri $SitesUri -Headers $headers
$DevicesRequest = Invoke-RestMethod -Method get -Uri $DeviceUri -Headers $headers

$InterfacesRequest = Invoke-RestMethod -Method get -Uri $InterfaceUri -Headers $headers

Invoke-RestMethod -Method Post -Uri $InterfaceUri -Headers $headers -Body ($Form | ConvertTo-Json -Depth 100)

$SitesRequest.results
$DevicesRequest.results[0]
$InterfacesRequest.results


#Create Devvice

$ServerName = "Servertestapi"
$DeviceForm = @{
     name        = "$ServerName"
     serial      = 'abc123'
     device_type = @{  model = "740"; slug = "740" }
     device_role = @{ name = "ESXi"; slug = "server" }
     status      = "active"
     site        = @{ name = "sitea" ; slug = "sitea" }
     description = "jahej"
}

Invoke-RestMethod -Method Post -Uri $DeviceUri -Headers $headers -Body ($DeviceForm | ConvertTo-Json -Depth 100)


#Create Server interface  

$InterfaceName = "Nic2"
$InterfaceForm = @{
     name               = "$InterfaceName"
     device             = @{ name = "$ServerName" }
     type               = "1000base-t"
     link_peer          = @{ name = "port1/1"; cable = "1"; _occupied = "True" }
     enabled            = "True"
     connected_endpoint = @{ name = "port1/1"; cable = "1"; _occupied = "True" }
     cable              = @{ display = "#1" }
     description        = "jahej"
}

Invoke-RestMethod -Method Post -Uri $InterfaceUri -Headers $headers -Body ($InterfaceForm | ConvertTo-Json -Depth 100)


#Create Server Connection to interface  

$ServerNicid = $InterfacesRequest.results | Where-Object { $_.name -eq $InterfaceName -and $_.device.name -eq $ServerName }
$SwitchNicid = $InterfacesRequest.results | Where-Object { $_.name -eq "port1/3" -and $_.device.name -eq "switch1" }

$CableForm = @{
     
     termination_a_type = "dcim.interface"
     termination_a_id   = $ServerNicid.id
     termination_a      = @{  device = "$ServerName" ; name = "$InterfaceName" }
     termination_b_type = "dcim.interface"
     termination_b      = @{  device = "switch1"; name = "port1/2" }
     termination_b_id   = $SwitchNicid.id
     
}

Invoke-RestMethod -Method Post -Uri $CableUri -Headers $headers -Body ($CableForm | ConvertTo-Json -Depth 100)
