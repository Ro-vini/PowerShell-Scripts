$remoteComputerName = "NomeComputador"  # Substitua pelo nome do computador que quer acessar
$cred = Get-Credential  # Solicita credenciais

# Conectar-se ao computador remoto e executar as ações
Invoke-Command -ComputerName $remoteComputerName -Credential $cred -ScriptBlock {

    # Alterar a política de execução no computador
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

    # Instalar o módulo PSWindowsUpdate
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Host "Instalando o módulo PSWindowsUpdate..."
        Install-Module -Name PSWindowsUpdate -Force -AllowClobber
    }

    # Importar o módulo PSWindowsUpdate
    Import-Module PSWindowsUpdate

    # Listar as atualizações disponíveis
    $updates = Get-WindowsUpdate
    if ($updates.Count -eq 0) {
        Write-Host "Não há atualizações disponíveis."
        return
    }

    Write-Host "As seguintes atualizações estão disponíveis:"
    $updates | Select-Object -Property Title, KBArticleID, Size | Format-Table

    $userChoice = Read-Host "Deseja instalar as atualizações? (S/N)"

    if ($userChoice -eq 'S' -or $userChoice -eq 's') {
        Write-Host "Instalando as atualizações..."
        Install-WindowsUpdate -AcceptAll -AutoReboot
    } else {
        Write-Host "Atualizações não instaladas."
    }
} -ArgumentLis
