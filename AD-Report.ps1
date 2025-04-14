Get-ADUser -Filter * -properties SamAccountName, Enabled, l, DisplayName, Manager, EmailAddress, description, LastLogon |
select SamAccountName, Enabled, l,  DisplayName, Manager, EmailAddress, description,@{N='LastLogon'; E={[DateTime]::FromFileTime($_.LastLogon)}} |
Export-Csv PATH -NoTypeInformation #Entre com o path da saida do relatorio
