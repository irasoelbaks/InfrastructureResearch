Get-DnsServerResourceRecord -ZoneName research.lab -ComputerName 'dc01' -RRType A | Where-Object {$_.HostName -like '*dc*'}
$ReverseLookupZones = Get-DnsServerZone -ComputerName 'dc01' | Where-Object {($_.IsAutoCreated -eq $false) -and ($_.IsReverseLookupZone)}
ForEach ($Zone in $ReverseLookupZones) {
Write-Host "Aan het kijken in: $Zone.ZoneName"
Get-DnsServerResourceRecord -ZoneName $Zone.ZoneName -ComputerName 'dc01'
}
Get-DnsServerZoneScope -ZoneName research.lab -ComputerName 'dc01'