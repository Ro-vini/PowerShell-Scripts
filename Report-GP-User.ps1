$sessao = New-PSSession -ComputerName "NomeComputador" -Credential (Get-Credential)

Invoke-Command -Session $sessao -ScriptBlock {
    gpresult /USER "DOMINIO\User" /h C:\resultado_gp_usuario_remoto.html
}

Remove-PSSession -Session $sessao

 
