#Create a File PS repository

# Register a file share on my local machine
$Share = "\\localhost\PSRepository"
$Name = "CC-Repository"
Register-PSRepository -Name $Name-SourceLocation $Share -ScriptSourceLocation $Share -InstallationPolicy Trusted

Get-PSRepository

# Publish to a file share repo - the NuGet API key must be a non-blank string
$ModulePath = "E:\Users\Carl C\Documents\WindowsPowerShell\Modules\NovelScripts"
Publish-Module -Path $ModulePath -Repository "$Name-SourceLocation" -NuGetApiKey 'AnyStringWillDo'

Find-Module -Repository CC-Repository-SourceLocation

Install-Module -Repository Repository-SourceLocation -Name NovelScripts -Scope AllUsers


if (condition) {
     
}

switch (${variable}) {
     condition { action; break }
     Default {}
}

switch ($x) {
     condition { switch ($x) {
      condition {  }
      Default {}
 } }
     Default {}
}


switch ($x) {
     condition {  }
     Default {}
}


switch ($x) {
     condition {  }
     Default {}
}