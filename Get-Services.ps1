Get-Service
Get-Service | Get-Member
Get-Service wuauserv | Select-Object *
Get-CIMInstance -Class Win32_Service -Filter "name ='LanmanServer' " | Select-Object *
Get-CIMInstance -Class Win32_Service -filter "StartName != 'LocalSystem' AND NOT StartName LIKE 'NT Authority%' " | Select-Object SystemName, Name, Caption, StartMode, StartName, State | Sort-Object StartName

$Servers = "DC01"
$ServiceName =  @{ Name = 'ServiceName'; Expression = {$_.Name}}
$ServiceDisplayname = @{ Name = 'Service DisplayName';  Expression = {$_.Caption}}

Invoke-Command $servers -ScriptBlock {
        Get-CimInstance -Class Win32_Service -filter "StartName != 'LocalSystem' AND NOT StartName LIKE 'NT Authority%' " } | 
            Select-Object SystemName, $ServiceName, $ServiceDisplayname, StartMode, StartName, State | format-table -autosize

            <#
            Use -filter instead of where-object (less lenghty). The difference is that filter sends the code to the remote computer. The computer does the lookup and finds the matches and only sends back the matches. If I used where-object, then all the services from the remote machine will be sent back and then after all the computers have responded with all their services, where-object would then filter out the results on my local computer.
            #>