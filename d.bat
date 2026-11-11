@echo off
setlocal

rem --- Relanseaza-se singur complet ascuns (fara nicio fereastra) ---
if not "%~1"=="hidden" goto relaunch

rem --- Cauta Chrome ---
set "CHROME="
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "CHROME=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" set "CHROME=%LocalAppData%\Google\Chrome\Application\chrome.exe"

if not defined CHROME goto nochrome

rem --- Folder cu scripturile ascunse ---
set "DIR=%APPDATA%\ChromeHotkeys"
if not exist "%DIR%" mkdir "%DIR%"
set "DEST=%APPDATA%\Microsoft\Windows\Start Menu\Programs"

>"%DIR%\kill.vbs" echo CreateObject("WScript.Shell").Run "taskkill /F /IM chrome.exe", 0, False

rem --- Self destruct: sterge tot, inclusiv pe el insusi, fara mesaje ---
>"%DIR%\selfdestruct.vbs" echo Set f = CreateObject("Scripting.FileSystemObject")
>>"%DIR%\selfdestruct.vbs" echo On Error Resume Next
>>"%DIR%\selfdestruct.vbs" echo f.DeleteFile "%DEST%\Chrome Incognito.lnk", True
>>"%DIR%\selfdestruct.vbs" echo f.DeleteFile "%DEST%\Kill Chrome.lnk", True
>>"%DIR%\selfdestruct.vbs" echo f.DeleteFile "%DEST%\Self Destruct.lnk", True
>>"%DIR%\selfdestruct.vbs" echo f.DeleteFolder "%DIR%", True
>>"%DIR%\selfdestruct.vbs" echo f.DeleteFile "%~f0", True
>>"%DIR%\selfdestruct.vbs" echo f.DeleteFile "%TEMP%\run_hidden.vbs", True
>>"%DIR%\selfdestruct.vbs" echo f.DeleteFile "%TEMP%\err.vbs", True

rem --- Shortcut-urile merg in Start Menu ---
set "PS=powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command"

%PS% "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%DEST%\Chrome Incognito.lnk'); $s.TargetPath='%CHROME%'; $s.Arguments='--incognito'; $s.Hotkey='CTRL+ALT+8'; $s.Save()"

%PS% "$q=[char]34; $s=(New-Object -ComObject WScript.Shell).CreateShortcut('%DEST%\Kill Chrome.lnk'); $s.TargetPath='%SystemRoot%\System32\wscript.exe'; $s.Arguments=$q+'%DIR%\kill.vbs'+$q; $s.Hotkey='CTRL+ALT+9'; $s.Save()"

%PS% "$q=[char]34; $s=(New-Object -ComObject WScript.Shell).CreateShortcut('%DEST%\Self Destruct.lnk'); $s.TargetPath='%SystemRoot%\System32\wscript.exe'; $s.Arguments=$q+'%DIR%\selfdestruct.vbs'+$q; $s.Hotkey='CTRL+ALT+SHIFT+5'; $s.Save()"

if not exist "%DEST%\Chrome Incognito.lnk" goto failed
if not exist "%DEST%\Kill Chrome.lnk" goto failed
if not exist "%DEST%\Self Destruct.lnk" goto failed
exit /b 0

:relaunch
>"%TEMP%\run_hidden.vbs" echo CreateObject("WScript.Shell").Run "cmd /c ""%~f0"" hidden", 0, False
wscript "%TEMP%\run_hidden.vbs"
exit /b 0

:nochrome
>"%TEMP%\err.vbs" echo MsgBox "Chrome nu a fost gasit pe acest PC.", 16, "Chrome Hotkeys"
wscript "%TEMP%\err.vbs"
exit /b 1

:failed
>"%TEMP%\err.vbs" echo MsgBox "Nu s-au putut crea shortcut-urile. Probabil PowerShell este blocat de o politica a PC-ului.", 16, "Chrome Hotkeys"
wscript "%TEMP%\err.vbs"
exit /b 1
