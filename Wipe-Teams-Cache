$remoteComputer = "NomeComputador"  # Substitua com o nome do computador que quer acessar

# Obtém o nome do usuário logado
$loggedInUser = Invoke-Command -ComputerName $remoteComputer -ScriptBlock {
    (Get-WmiObject -Class Win32_ComputerSystem).UserName
}

# Verifica se há um usuário logado
if ($loggedInUser) {
    Write-Host "Usuário logado: $loggedInUser"

    # Caminho do cache do Microsoft Teams
    $cachePaths = @(
        [System.IO.Path]::Combine("C:\Users", $loggedInUser.Split('\')[1], 'AppData\Local\Microsoft\Teams'),
        [System.IO.Path]::Combine("C:\Users", $loggedInUser.Split('\')[1], 'AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams')
    )

    # Fechar o Microsoft Teams (se estiver aberto)
    Invoke-Command -ComputerName $remoteComputer -ScriptBlock {
        Stop-Process -Name "Teams" -Force -ErrorAction SilentlyContinue
        Stop-Process -Name "ms-teams" -Force -ErrorAction SilentlyContinue
    }

    # Remover os itens de cache
    Invoke-Command -ComputerName $remoteComputer -ScriptBlock {
        foreach ($cachePath in $using:cachePaths) {
            if (Test-Path $cachePath) {
                Write-Host "Limpando o cache em: $cachePath"
                Remove-Item -Path $cachePath -Recurse -Force -ErrorAction SilentlyContinue
            } else {
                Write-Host "Caminho não encontrado: $cachePath"
            }
        }
    } -Credential (Get-Credential)
 
    Write-Host "Cache limpo com sucesso para o usuário $loggedInUser."

} 
else {
    Write-Host "Nenhum usuário está logado no computador remoto."
}
