Enable-PSRemoting -Force

Invoke-Command -ComputerName NomeComputador -ScriptBlock { # Digite nome do computador para descobrir o MAC
    Get-NetAdapter | Where-Object {$_.Status -match 'Up'} | Select-Object ifIndex, Name, Status, MacAddress
}
