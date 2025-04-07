@echo off
REM Example Batch Script for Windows 11 Pro (example.cmd)

REM --- Basic Output and Variables ---
echo.
echo Hello from a Batch Script on Windows 11 Pro!
set "userName=%USERNAME%"
echo Current user: %userName%
echo.

REM --- Date and Time ---
echo --- Date and Time ---
echo Current date: %DATE%
echo Current time: %TIME%
echo.

REM --- System Information ---
echo --- System Information ---
echo Operating System: %OS%
ver
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
echo.

REM --- Directory and File Operations ---
echo --- Directory and File Operations ---
echo Current directory: %CD%
mkdir "TestDirectory" 2>nul
if %errorlevel% equ 0 (
    echo Created directory: TestDirectory
) else (
    echo Directory already exists: TestDirectory
)

echo This is a test file. > "TestDirectory\TestFile.txt"
echo Created file: TestDirectory\TestFile.txt

echo File content:
type "TestDirectory\TestFile.txt"
echo.

REM --- Looping ---
echo --- Looping ---
echo Numbers:
for /L %%i in (1,1,5) do (
    echo %%i
)
echo.

REM --- Conditional Logic ---
echo --- Conditional Logic ---
if "%OS%" == "Windows_NT" (
    echo Running on a Windows NT-based system.
) else (
    echo Not running on a Windows NT-based system.
)
echo.

REM --- Running External Commands ---
echo --- Running External Commands ---
echo IP Configuration:
ipconfig
echo.

REM --- Environment Variables ---
echo --- Environment Variables ---
echo Path: %PATH%
echo SystemRoot: %SystemRoot%
echo.

REM --- Error Handling ---
echo --- Error Handling ---
REM Attempt to access a non-existent file
type "NonExistentFile.txt" 2>nul
if %errorlevel% neq 0 (
    echo An error occurred: Could not find file.
)
echo.

REM --- Cleanup ---
echo --- Cleanup ---
del "TestDirectory\TestFile.txt" 2>nul
rmdir "TestDirectory" 2>nul
echo Removed TestFile.txt and TestDirectory
echo.

echo Script completed.
pause
