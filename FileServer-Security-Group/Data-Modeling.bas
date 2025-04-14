Attribute VB_Name = "Módulo1"
Sub AnalisarEAlterarLinhas()
    Dim ws As Worksheet
    Dim i As Long
    Dim lastRow As Long
    Dim valorD As String
    Dim valorE As String
    Dim valorF As String
    Dim valorA As String
    Dim dict As Object

    Set dict = CreateObject("Scripting.Dictionary")
    
    ' Definir a planilha atual
    Set ws = ThisWorkbook.Sheets("FolderPermissions") ' Altere o nome da planilha conforme necessário

    ' Encontrar a última linha da coluna D
    lastRow = ws.Cells(ws.Rows.Count, "D").End(xlUp).Row

    ' Loop para percorrer as linhas
    For i = lastRow To 2 Step -1 ' Começa da última linha e vai até a linha 2 (linha 1 é cabeçalho)
        valorD = ws.Cells(i, "D").Value
        valorE = ws.Cells(i, "E").Value
        valorF = ws.Cells(i, "F").Value
        valorA = ws.Cells(i, "A").Value

        'Possiveis grupos de segurança que não são necessários
        If Not Left(valorD, 3) = "" Or InStr(valorD, "") Or InStr(valorD, "") > 0 Then
            ws.Rows(i).Delete
        Else
            ' Se a coluna E ou F tiver "X", substituir o conteúdo da coluna E ou F pela coluna D
            If valorE = "X" Then
                ws.Cells(i, "E").Value = valorD
            End If
            If valorF = "X" Then
                ws.Cells(i, "F").Value = valorD
            End If
           
            ' Comparar a coluna A para duplicidades
            If dict.exists(valorA) Then
                ' Se já existir um valor igual em uma linha anterior
                ' Verifica E ou F e copia para a célula correspondente acima
                If ws.Cells(dict(valorA), "E").Value = "" And ws.Cells(i, "E").Value <> "" Then
                    ws.Cells(dict(valorA), "E").Value = ws.Cells(i, "E").Value
                    ws.Cells(i, "E").ClearContents
                ElseIf ws.Cells(dict(valorA), "F").Value = "" And ws.Cells(i, "F").Value <> "" Then
                    ws.Cells(dict(valorA), "F").Value = ws.Cells(i, "F").Value
                    ws.Cells(i, "F").ClearContents
                End If
            Else
                ' Adiciona o valor da célula da coluna A no dicionário com o número da linha
                dict.Add valorA, i
            End If
        End If
    Next i

    ' Apagar as linhas onde E e F estão vazias
    For i = lastRow To 2 Step -1 ' Começa da última linha e vai até a linha 2
        valorE = ws.Cells(i, "E").Value
        valorF = ws.Cells(i, "F").Value
        ' Se tanto E quanto F estão vazias, exclui a linha
        If valorE = "" And valorF = "" Then
            ws.Rows(i).Delete
        End If
    Next i

End Sub
