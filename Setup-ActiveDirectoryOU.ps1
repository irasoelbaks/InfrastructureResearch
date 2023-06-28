New-ADOrganizationalUnit -Name "Servers" -Verbose
New-ADOrganizationalUnit -Name "Productie Servers" -Path "OU=Servers,DC=research,DC=lab" -Verbose
New-ADOrganizationalUnit -Name "Test Servers" -Path "OU=Servers,DC=research,DC=lab" -Verbose

New-ADOrganizationalUnit -Name "Groepen" -Verbose
New-ADOrganizationalUnit -Name "Gebruikers Groepen" -Path "OU=Groepen,DC=research,DC=lab" -Verbose
New-ADOrganizationalUnit -Name "Rechten Groepen" -Path "OU=Groepen,DC=research,DC=lab" -Verbose

New-ADOrganizationalUnit -Name "Gebruikers" -Verbose
New-ADOrganizationalUnit -Name "Admin Accounts" -Path "OU=Gebruikers,DC=research,DC=lab" -Verbose
New-ADOrganizationalUnit -Name "Gebruikers Accounts" -Path "OU=Gebruikers,DC=research,DC=lab" -Verbose

(Get-ADOrganizationalUnit -Filter 'Name -like "Servers"').DistinguishedName