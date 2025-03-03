@echo off
color 3
echo ======================================
echo    PORT PROCESS KILLER UTILITY
echo ======================================
echo.

set /p port="Enter the port number to kill processes: "

echo.
echo Searching for processes using port %port%...
echo.

:: Find process using the specified port and kill it
for /f "tokens=5" %%a in ('netstat -ano ^| find ":%port% "') do (
    set pid=%%a
    echo Found process with PID: %%a
    taskkill /F /PID %%a
    echo Process with PID %%a has been terminated.
)

echo.
echo All processes using port %port% have been terminated.
echo Closing in 3 seconds...
timeout /t 3 /nobreak > nul
exit