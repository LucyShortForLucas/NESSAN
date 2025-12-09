@echo off
setlocal enabledelayedexpansion

set CA65=C:\cc65\bin\ca65.exe
set LD65=C:\cc65\bin\ld65.exe

if not exist build mkdir build

echo Assembling .s files from asm\
set FILELIST=
for %%f in (asm\*.s) do (
    echo Assembling %%f ...
    "%CA65%" "%%f" -g -o "build\%%~nf.o"
    if errorlevel 1 exit /b 1
    set FILELIST=!FILELIST! build\%%~nf.o
)

echo Linking...
"%LD65%" -t nes -o build\CoinHeist.nes !FILELIST! --dbgfile build\CoinHeist.dbg
if errorlevel 1 exit /b 1

echo Build complete: build\CoinHeist.nes

set total = 0
for /f "tokens=2,3" %%A in (asm\zeropage.s) do (
    if "%%A"==".res" (
        set /a total+=%%B
    )
)

echo Total zero page bytes used: %total% / 256

set total = 0
for /f "tokens=2,3" %%A in (asm\bss.s) do (
    if "%%A"==".res" (
        set /a total+=%%B
    )
)

echo Total bss bytes used: %total%

endlocal