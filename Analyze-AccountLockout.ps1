Search-ADAccount -LockedOut
$pdce=(Get-ADDomain).PDCEmulator
Get-WinEvent -ComputerName $pdce -FilterHashTable @{'LogName' ='Security';'Id' = 4740}

$events = Get-WinEvent -ComputerName $pdce -FilterHashTable @{'LogName' = 'Security';'Id' = 4740}
$events | Select-Object @{'Name' ='UserName'; Expression={$_.Properties[0]}}, @{'Name' ='ComputerName';Expression={$_.Properties[1]}}
$Start=(Get-Date).AddDays(-1)
Get-WinEvent -FilterHashTable @{LogName="Security"; ID=4740;StartTime=$Start}| Select-Object TimeCreated, Message | Format-Table -Wrap

Unlock-ADAccount -Identity 'lockeduser'

Get-ADUser -Identity srasoelbaks -Properties * | Select-Object LockedOut, AccountLockoutTime, BadLogonCount


# Creating filter criteria for events
$filterHash = @{LogName = "Security"; Id = 4740; StartTime = (Get-Date).AddDays(-1)}
# Getting lockout events from the PDC emulator
$lockoutEvents = Get-WinEvent -ComputerName $pdce -FilterHashTable $filterHash -ErrorAction SilentlyContinue
# Building output based on advanced properties
$lockoutEvents | Select @{Name = "LockedUser"; Expression = {$_.Properties[0].Value}}, `
                        @{Name = "SourceComputer"; Expression = {$_.Properties[1].Value}}, `
                        @{Name = "DomainController"; Expression = {$_.Properties[4].Value}}, TimeCreated


# Creating filter criteria for events
$filterHash = @{LogName = "Security"; Id = 4625; StartTime = (Get-Date).AddDays(-1)}
# Getting lockout events from the source computer
$lockoutEvents = Get-WinEvent -ComputerName app02.research.lab -FilterHashTable $filterHash -MaxEvents 1 -ErrorAction 0
# Building output based on advanced properties
$lockoutEvents | Select @{Name = "LockedUserName"; Expression = {$_.Properties[5].Value}}, `
                        @{Name = "LogonType"; Expression = {$_.Properties[10].Value}}, `
                        @{Name = "LogonProcessName"; Expression = {$_.Properties[11].Value}}, `
                        @{Name = "ProcessName"; Expression = {$_.Properties[18].Value}}
# Get-WinEvent : The remote procedure call failed = Firewall issue


