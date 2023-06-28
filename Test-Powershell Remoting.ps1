# Test of PS Remoting het doet
$ComputerName = 'app01.research.lab'
Test-WSMan -ComputerName $ComputerName
# Ping
Test-Connection -ComputerName $ComputerName -Quiet