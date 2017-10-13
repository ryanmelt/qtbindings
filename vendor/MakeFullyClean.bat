:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Builds Windows 32-bit and 64-bit gems for Windows
:: Usage: BuildWindowsGems VERSION
::
:: Make sure you have installed the following before running:
::   a. Windows SDK for Windows version you are on
::   b. Cmake
::   c. The 32-bit and 64-bit versions of Devkit
::      And you have run PatchDevkit32.bat and PatchDevkit64.bat
::   d. Qt built with Devkit for both 32-bit and 64-bit
::      See BuildQt4Win32.bat and BuildQt4Win64.bat
::   e. Ruby version 2.0 to 2.3 both 32-bit and 64-bit version
::   f. Update all the paths below to your installations
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

set DEVKIT_32_PATH=C:\Devkit32
set DEVKIT_64_PATH=C:\Devkit64
set QT_32_PATH=C:\Qt\4.8.6
set Qt_64_PATH=C:\Qt\4.8.6-64
set RUBY20_32_PATH=C:\Ruby200p648
set RUBY20_64_PATH=C:\Ruby200p648-x64
set RUBY21_32_PATH=C:\Ruby219
set RUBY21_64_PATH=C:\Ruby219-x64
set RUBY22_32_PATH=C:\Ruby225
set RUBY22_64_PATH=C:\Ruby225-x64
set RUBY23_32_PATH=C:\Ruby231
set RUBY23_64_PATH=C:\Ruby231-x64
set CMAKE_PATH="C:\Program Files (x86)\CMake 2.8"

:: Down to the main directory
cd ..

:: 32-bit version

set QTBINDINGS_QT_PATH=!QT_32_PATH!
set PATH=!DEVKIT_32_PATH!\mingw\bin;!CMAKE_PATH!\bin;!QT_32_PATH!\bin;%PATH%

:: Cleanup
set PATH=!RUBY20_32_PATH!\bin;%PATH%
call rake distclean
set PATH=!RUBY21_32_PATH!\bin;%PATH%
call rake distclean
set PATH=!RUBY22_32_PATH!\bin;%PATH%
call rake distclean
set PATH=!RUBY23_32_PATH!\bin;%PATH%
call rake distclean

:: 64-bit version

set QTBINDINGS_QT_PATH=!QT_64_PATH!
set PATH=!DEVKIT_64_PATH!\mingw\bin;!CMAKE_PATH!\bin;!QT_64_PATH!\bin;%PATH%

:: Cleanup
set PATH=!RUBY20_64_PATH!\bin;%PATH%
call rake distclean
set PATH=!RUBY21_64_PATH!\bin;%PATH%
call rake distclean
set PATH=!RUBY22_64_PATH!\bin;%PATH%
call rake distclean
set PATH=!RUBY23_64_PATH!\bin;%PATH%
call rake distclean

:exit

