# Machine Name
$ComputerName = 'DC01'
Rename-Computer -NewName $ComputerName -Restart

# Create credentials
$User = 'RESEARCH\Administrator'
$PWord = ConvertTo-SecureString -String '' -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

# Domain Controller Setup
Get-NetAdapter
New-NetIPAddress -IPAddress '192.168.2.200' -AddressFamily IPv4 -InterfaceAlias 'Ethernet' -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias 'Ethernet' -ServerAddresses 127.0.0.1
Install-WindowsFeature AD-Domain-Services
$SafeModeAdministratorPassword = $PWord
Install-ADDSForest -DomainName 'research.lab' -SafeModeAdministratorPassword $SafeModeAdministratorPassword -Force -CreateDnsDelegation:$false

# Machine Configuration
Set-Service -Name wuauserv -StartupType Disabled -Verbose
Stop-Service -Name wuauserv -Force -Verbose
New-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -PropertyType DWORD -Value "0x1" -Force -Verbose
Powercfg -Setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# DNS Reverse Zone Lookup + PTR Record
Add-DnsServerPrimaryZone -NetworkId 192.168.2.0/24 -ReplicationScope Domain
Add-DnsServerResourceRecordPtr -Name '2' -ZoneName '2.168.192.in-addr.arpa' -PtrDomainName 'dc01.research.lab' -Verbose -AllowUpdateAny
Get-DnsServerZone

# Disk Maintenance
Get-Volume
Repair-Volume -DriveLetter C -Scan -Verbose # Reports errors only
Optimize-Volume -DriveLetter C -Analyze -Verbose # Reports only the current optimization state of drive H


# Clear event log, Optimze-Volume, Repair Volum and Dcdiag
Get-EventLog -LogName * | ForEach-Object { Clear-EventLog $_.Log }
Optimize-Volume -DriveLetter C -Analyze -Defrag -SlabConsolidate -Retrim -Verbose
Repair-Volume -DriveLetter C -OfflineScanAndFix -Verbose # Switch indicates the volume should be taken offline and scanned in full.
$result = dcdiag /s:DC01 # dcdiag /s:DC01 /test:dns
    $result | select-string -pattern '\. (.*) \b(passed|failed)\b test (.*)' | ForEach-Object {
        $obj = @{
            TestName = $_.Matches.Groups[3].Value
            TestResult = $_.Matches.Groups[2].Value
            Entity = $_.Matches.Groups[1].Value
        }
        [pscustomobject]$obj
    }


