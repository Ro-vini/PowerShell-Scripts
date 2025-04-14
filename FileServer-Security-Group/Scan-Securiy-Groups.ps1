# Definir o caminho da pasta raiz para iniciar varredura
$rootPath = "PastaRaiz"

# Obter todas as pastas dentro do caminho especificado
$folders = Get-ChildItem -Path $rootPath -Directory -Recurse


# Criar uma lista para armazenar os resultados
$results = @()

# Divide o caminho em partes e obtém o nome da pasta anterior
$pathParts = $folderPath -split '\\'

# Função para obter o nome da pasta anterior
function Get-LastPathName {
    param(
        [string]$folderPath
    )

    # Verifique se o caminho está vazio ou se não há subpastas
    if ([string]::IsNullOrEmpty($folderPath)) {
        return ""  # Retorna string vazia se não houver caminho
    }

    # Divide o caminho em partes e obtém o nome da pasta anterior
    $pathParts = $folderPath -split '\\'

    # Se houver mais de uma pasta, retorne o nome da pasta anterior
    if ($pathParts.Length -gt 1) {
        return $pathParts[$pathParts.Length - 2]  # Nome da pasta anterior
    } else {
        return ""  # Retorna uma string vazia se não houver pasta anterior
    }
}

foreach ($folder in $folders) {
    # Obter as permissões de segurança da pasta
    $acl = Get-Acl -Path $folder.FullName

    # Iterar sobre cada permissão
    foreach ($access in $acl.Access) {
        # Verificar se o acesso inclui leitura e escrita
        $read = if ($access.FileSystemRights -match "Read") { "X" } else { "" }
        $write = if ($access.FileSystemRights -match "Write|Modify|FullControl") { "X" } else { "" }

        # Obtenha o nome da pasta anterior
        $lastPathName = Get-LastPathName -folderPath $folder.FullName

        # Criar um objeto para armazenar os dados
        $obj = [PSCustomObject]@{

            "UNC Path" = $folder.FullName
            "Name" = $folder.Name
            "LastPathName" = $lastPathName
            "Security Group/User" = $access.IdentityReference
            "Read Access" = $read
            "Write Access" = $write

        }

        # Adicionar o objeto à lista de resultados
        $results += $obj
    }
}

# Exibir a saída formatada
$results | Format-Table -AutoSize

# Exportar para CSV
$results | Export-Csv -Path "C:\temp\FolderPermissions.csv" -NoTypeInformation -Encoding UTF8
