Dim shell
Set shell = CreateObject("WScript.Shell")
shell.Run "powershell -ExecutionPolicy Bypass -File """ & CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName) & "\update.ps1""", 0, False