# Installeer DFS
Install-WindowsFeature FS-DFS-Namespace,FS-DFS-Replication,RSAT-DFS-Mgmt-Con -Verbose
# Maak directory
New-Item -ItemType Directory -Path 'C:\Data\Company' -Force -Verbose
New-Item -ItemType Directory -Path 'C:\Data\User' -Force -Verbose
# Maak share aan
New-SmbShare -Name 'CompanyData' -Path 'C:\Data\Company' -FullAccess 'Everyone'
New-SmbShare -Name 'UserData' -Path 'C:\Data\User' -FullAccess 'Everyone'
# Create DFS namespace manually (Domain Bases + Windows 2008 Mode for ABE and Increased scalability)
# Create DFS namespace folder
New-DfsnFolder -Path '\\research.lab\Data\CompanyData' -TargetPath '\\dc01\CompanyData'
New-DfsnFolder -Path '\\research.lab\Data\UserData' -TargetPath '\\dc01\UserData'