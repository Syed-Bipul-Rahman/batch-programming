@echo off
setlocal enabledelayedexpansion

REM Create a temporary VBS script to properly handle JSON
echo Option Explicit > "%temp%\json_extract.vbs"
echo Dim jsonText, objRegExp, matches >> "%temp%\json_extract.vbs"
echo Dim fso, textFile >> "%temp%\json_extract.vbs"
echo Set fso = CreateObject("Scripting.FileSystemObject") >> "%temp%\json_extract.vbs"
echo Set textFile = fso.OpenTextFile("response.json", 1) >> "%temp%\json_extract.vbs"
echo jsonText = textFile.ReadAll >> "%temp%\json_extract.vbs"
echo textFile.Close >> "%temp%\json_extract.vbs"
echo Set objRegExp = New RegExp >> "%temp%\json_extract.vbs"
echo objRegExp.Global = True >> "%temp%\json_extract.vbs"
echo objRegExp.Pattern = """text"":\s*""(.+?)""" >> "%temp%\json_extract.vbs"
echo Set matches = objRegExp.Execute(jsonText) >> "%temp%\json_extract.vbs"
echo If matches.Count ^> 0 Then >> "%temp%\json_extract.vbs"
echo     Dim extractedText >> "%temp%\json_extract.vbs"
echo     extractedText = matches(0).SubMatches(0) >> "%temp%\json_extract.vbs"
echo     extractedText = Replace(extractedText, "\n", vbCrLf) >> "%temp%\json_extract.vbs"
echo     extractedText = Replace(extractedText, "\\", "\") >> "%temp%\json_extract.vbs"
echo     WScript.Echo extractedText >> "%temp%\json_extract.vbs"
echo Else >> "%temp%\json_extract.vbs"
echo     WScript.Echo "No text found in response." >> "%temp%\json_extract.vbs"
echo End If >> "%temp%\json_extract.vbs"

:loop
REM Prompt the user for input
set /p userInput=Enter your question or prompt (Ctrl+C to exit): 

REM Execute the curl command with the user's input
curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyDbBeNwdGReyIj8A_qHDlROG075JVdhbpA" ^
-H "Content-Type: application/json" ^
-X POST ^
-d "{\"contents\": [{\"parts\":[{\"text\": \"%userInput%\"}]}]}" > response.json

REM Use the VBS script to extract and properly format the text
for /f "delims=" %%a in ('cscript //nologo "%temp%\json_extract.vbs"') do (
    echo %%a
)

REM Clean up
del response.json >nul 2>&1

goto loop