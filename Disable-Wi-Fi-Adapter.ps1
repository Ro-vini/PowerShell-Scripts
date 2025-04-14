$computadorRemoto = "NomeComputador"  # Substitua pelo nome ou IP do computador que quer acessar

# Iniciar uma sessão remota usando as credenciais de Administrador
$sessao = New-PSSession -ComputerName $computadorRemoto -Authentication Negotiate -Credential (Get-Credential)

# Usando a sessão para desabilitar a interface Wi-Fi
Invoke-Command -Session $sessao -ScriptBlock {
    # Obter o adaptador de rede Wi-Fi
    $wifiAdapter = Get-NetAdapter | Where-Object { $_.Name -like "*Wi-Fi*" }

    # Desabilitar o adaptador Wi-Fi
    if ($wifiAdapter) {
        Disable-NetAdapter -Name $wifiAdapter.Name -Confirm:$false
    } else {
        Write-Host "Adaptador Wi-Fi não encontrado."
    }
}

Remove-PSSession -Session $sessao
Write-Host "Sessão remota fechada."
