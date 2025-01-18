#OpenSSL skript

Function Convert-PFXToPem {
     <#
.Synopsis
   Converts a PFX certificate to a PEM(base64)
.DESCRIPTION
   Extracts the certificate from a PFX(Windows) certificate and stores it as a base64 PEM format.
   It requeres OpenSSL to function.
   Note: Its important that the PFX password is 4 characters or more or else OpenSSL will fail
.EXAMPLE
Convert-PFXToPem -OpenSSLPath "C:\Program Files\Git\usr\bin" -CertPath "C:\Skripts\openssltest" -Password (ConvertTo-SecureString -String "abcd" -AsPlainText -Force)
.ROLE
   Certificate management.
.FUNCTIONALITY
   A convertion function.
#>
     [CmdletBinding(DefaultParameterSetName = 'OnePassword')]
     [Alias()]
     Param
     (
          # PathToOpenSSL
          [Parameter(Mandatory = $true,
               ValueFromPipeline = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 0)]
          [string]$OpenSSLPath,
 
          # Path to pfx-files
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 1)]
          [string]
          $CertPath,

          # Pfx Password
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 2,
               ParameterSetName = 'OnePassword')]
          [System.Security.SecureString]
          $Password,

          # Pfx Password List
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 2,
               ParameterSetName = 'Passwordlist')]
          $PasswordList

     )

     Begin {
          $openssl = "openssl.exe"
          $Files = Get-ChildItem -Path $CertPath -Filter "*.pfx"

          Write-Verbose "$OpenSSLPath\$openssl"

     } #Begin
     Process { 
          foreach ($File in $Files) {
               $PEMName = $File.name -replace ".pfx", ".pem"
               Write-Verbose "PEMName: $PEMName"

               if ($Passwordlist -ne $null) {
                    
                    $Pass = $PasswordList | Where-Object filename -Match $($File.name)
                    Write-Verbose "Pass: $($Pass)"
                    $Password = ConvertTo-SecureString -String "$($Pass.password)" -AsPlainText -Force
                    Write-Verbose "Passwordlist password: $($Pass.Password)"
                    
               }#end if passwordlist

               $Parameters = @(
                    "pkcs12",
                    "-in $($File.fullname)",
                    "-password pass:$(ConvertFrom-SecureString -SecureString $Password -AsPlainText)",
                    "-out $CertPath\$PEMName",
                    "-passout pass:$(ConvertFrom-SecureString -SecureString $Password -AsPlainText)",
                    "-clcerts"
               )

               Write-Verbose "Params: $($Parameters)"
            

               $Proc = Start-Process -FilePath "$OpenSSLPath\$openssl" -ArgumentList $Parameters -Wait -PassThru -RedirectStandardError ".\Error.log"
          }#end foreach


     } #Process
     End {
          if ($Proc.ExitCode -gt 0) {
               $ErrorLog = Get-Content ".\Error.log"
               Write-Error "An Error occurred: $ErrorLog"
               Remove-Item ".\Error.log"
          }
          else {
               $Pems = Get-ChildItem -Path $CertPath -Filter "*.pem" | Where-Object LastWriteTime -GT $((Get-Date).AddMinutes(-2))
               Write-Host "Created PEM files"
               $Pems.Name
               Remove-Item ".\Error.log"
          }

     } #End

}#End function Convert-PFXToPem

Convert-PFXToPem -OpenSSLPath "C:\Program Files\Git\usr\bin" -CertPath "C:\Skripts\openssltest" -Password (ConvertTo-SecureString -String "abcd" -AsPlainText -Force) -Verbose
$Passwordlist = Import-Csv .\passwordlist
Convert-PFXToPem -OpenSSLPath "C:\Program Files\Git\usr\bin" -CertPath "C:\Skripts\openssltest" -PasswordList $Passwordlist -Verbose




Function Convert-PFXToKey {
     <#
.Synopsis
Exports the private key in encrypted and unecrypted form from a PFX file
.DESCRIPTION
Extracts the private key from a PFX(Windows) certificate and stores it as a base64 PEM format.
It requeres OpenSSL to function.
Note: Its important that the PFX password is 4 characters or more or else OpenSSL will fail
.EXAMPLE
Convert-PFXTpKey -OpenSSLPath "C:\Program Files\Git\usr\bin" -CertPath "C:\Skripts\openssltest" -Password (ConvertTo-SecureString -String "abcd" -AsPlainText -Force) -Verbose
.ROLE
Certificate management.
.FUNCTIONALITY
A convertion function.
#>
     [CmdletBinding(DefaultParameterSetName = 'OnePassword')]
     [Alias()]
     Param
     (
          # PathToOpenSSL
          [Parameter(Mandatory = $true,
               ValueFromPipeline = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 0)]
          [string]$OpenSSLPath,

          # Path to pfx-files
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 1)]
          [string]$CertPath,

          # Pfx Password
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 2,
               ParameterSetName = 'OnePassword')]
          [System.Security.SecureString]
          $Password,

          # Pfx Password List
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 2,
               ParameterSetName = 'Passwordlist')]
          $PasswordList

     )

     Begin {
          $openssl = "openssl.exe"
          $Files = Get-ChildItem -Path $CertPath -Filter "*.pfx"
          Write-Verbose "$OpenSSLPath\$openssl"
     } #Begin
     Process { 
          foreach ($File in $Files) {
               $KeyName = $File.name -replace ".pfx", ".key"
               Write-Verbose "KeyName: $KeyName"

               #Checks if there is a password list
               if ($Passwordlist -ne $null) {
          
                    $Pass = $PasswordList | Where-Object filename -Match $($File.name)
                    Write-Verbose "Pass: $($Pass)"
                    $Password = ConvertTo-SecureString -String "$($Pass.password)" -AsPlainText -Force
                    Write-Verbose "Passwordlist password: $($Pass.Password)"
          
               }#end if passwordlist

               #Exports the encrypted key
               $KeyParameters = @(
                    "pkcs12",
                    "-nocerts",
                    "-in $($File.fullname)",
                    "-password pass:$(ConvertFrom-SecureString -SecureString $Password -AsPlainText)",
                    "-out $CertPath\$KeyName",
                    "-passout pass:$(ConvertFrom-SecureString -SecureString $Password -AsPlainText)"
               )
               Write-Verbose "Params: $($KeyParameters)"

               $Proc1 = Start-Process -FilePath "$OpenSSLPath\$openssl" -ArgumentList $KeyParameters -Wait -PassThru -RedirectStandardError ".\Error1.log"

               $KeyUnName = $File.name -replace ".pfx", ".un.key"
               Write-Verbose "KeyUnName: $KeyUnName"
     
               #Exports the unencrypted key
               $KeyUnParameters = @(
                    "rsa",
                    "-in $CertPath\$KeyName",
                    "-passin pass:$(ConvertFrom-SecureString -SecureString $Password -AsPlainText)",
                    "-out $CertPath\$KeyUnName"
               )
               Write-Verbose "Params: $($KeyUnParameters)"
               $Proc2 = Start-Process -FilePath "$OpenSSLPath\$openssl" -ArgumentList $KeyUnParameters -Wait -PassThru -RedirectStandardError ".\Error2.log"
          }#end foreach


     } #Process
     End {
          if ($Proc1.ExitCode -gt 0 -or $Proc2.ExitCode -gt 0) {
               $ErrorLog1 = Get-Content ".\Error1.log"
               $ErrorLog2 = Get-Content ".\Error2.log"
               Write-Error "An Error occurred: $ErrorLog1 $ErrorLog2"
               Remove-Item ".\Error1.log"
               Remove-Item ".\Error2.log"
          }
          else {
               $Pems = Get-ChildItem -Path $CertPath -Filter "*.key" | Where-Object LastWriteTime -GT $((Get-Date).AddMinutes(-2))
               Write-Host "Created key files"
               $Pems.Name
               Remove-Item ".\Error1.log"
               Remove-Item ".\Error2.log"
          }
     } #End

}#End function Convert-PFXToKey

Convert-PFXToKey -OpenSSLPath "C:\Program Files\Git\usr\bin" -CertPath "C:\Skripts\openssltest" -Password (ConvertTo-SecureString -String "abcd" -AsPlainText -Force) -Verbose
Convert-PFXToKey -OpenSSLPath "C:\Program Files\Git\usr\bin" -CertPath "C:\Skripts\openssltest" -PasswordList $Passwordlist -Verbose



Function New-CodeSigningCert {
     Begin {
          $openssl = "C:\Program Files\Git\usr\bin\openssl.exe"
          Write-Verbose "$OpenSSLPath\$openssl"
     } #Begin


     Process {

          #Generate CSR

          $KeyParameters = @(
               "req",
               "-new",
               "-newkey rsa:3072",
               "-nodes",
               "-out C:\temp\code_signing_csr.txt",
               "-keyout C:\temp\code_signing_key.key",
               '-subj "/C=SE/ST=Stock/O=CC.jul/CN=cc"',
               '-addext "keyUsage = critical,digitalSignature"',
               '-addext "extendedKeyUsage = critical,codeSigning"'
          )
          Write-Verbose "Params: $($KeyParameters)"

          $Proc1 = Start-Process -FilePath "$openssl" -ArgumentList $KeyParameters -Wait -PassThru -RedirectStandardError "C:\temp\Error1.log"


     }

}