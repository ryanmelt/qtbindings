:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Builds Windows 32-bit and 64-bit gems for Windows
:: Usage: BuildWindowsGems VERSION
::
:: Make sure you have installed the following before running:
::   a. Windows SDK for Windows version you are on
::   b. Cmake
::   c. The 32-bit and 64-bit versions of msys2 for Ruby 2.4
::   d. Qt built with msys for both 32-bit and 64-bit Ruby 2.4
::      See BuildQt4Win32Ruby24.bat and BuildQt4Win64Ruby24.bat
::   e. Ruby version 2.4 both 32-bit and 64-bit version
::   f. Update all the paths below to your installations
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

IF [%1]==[] (
  @echo "Usage: BuildWindowsGems VERSION"
  goto exit
) else (
  set COSMOS_INSTALL=%~1
)
set MSYS64_32_PATH=C:\msys64
set MSYS64_64_PATH=C:\msys64
set QT_32_RUBY24_PATH=C:\Qt\4.8.6-Ruby24
set Qt_64_RUBY24_PATH=C:\Qt\4.8.6-64-Ruby24
set RUBY24_32_PATH=C:\Ruby242
set RUBY24_64_PATH=C:\Ruby242-x64
set RUBY25_32_PATH=C:\Ruby251
set RUBY25_64_PATH=C:\Ruby251-x64

:: Down to the main directory
cd ..
mkdir release

:: 32-bit version

:: Cleanup

set QTBINDINGS_QT_PATH=!QT_32_RUBY24_PATH!
set PATH=!MSYS64_32_PATH!\mingw32\bin;!QT_32_RUBY24_PATH!\bin;!PATH!
set PATH=!RUBY24_32_PATH!\bin;!PATH!
echo.
echo Cleanup
call ruby -e "puts RUBY_VERSION"
echo.
call rake distclean

:: Build 32-bit
echo.
echo Building 32-bit
echo.

echo.
echo Ruby
call ruby -e "puts RUBY_VERSION"
echo.
call rake build

set PATH=!RUBY25_32_PATH!\bin;!PATH!
echo.
echo Ruby
call ruby -e "puts RUBY_VERSION"
echo.
call rake build

echo.
echo Build 32-bit qtbindings gem
echo.
call rake VERSION=%1 gemnative

echo.
echo Build 32-bit qtbindings-qt gem
echo.
call rake VERSION=%1 gemqt

move *.gem release
move release\*.gemspec .

:: 64-bit version

:: Cleanup

set QTBINDINGS_QT_PATH=!QT_64_RUBY24_PATH!
set PATH=!MSYS64_64_PATH!\mingw64\bin;!QT_64_RUBY24_PATH!\bin;!PATH!
set PATH=!RUBY24_64_PATH!\bin;!PATH!
echo.
echo Cleanup
call ruby -e "puts RUBY_VERSION"
echo.
call rake distclean

:: Build 64-bit
echo.
echo Building 64-bit
echo.

echo.
echo Ruby
call ruby -e "puts RUBY_VERSION"
echo.
call rake build

set PATH=!RUBY25_64_PATH!\bin;!PATH!
echo.
echo Ruby
call ruby -e "puts RUBY_VERSION"
echo.
call rake build

echo.
echo Build 64-bit qtbindings gem
echo.
call rake VERSION=%1 gemnative

echo.
echo Build 64-bit qtbindings-qt gem
echo.
call rake VERSION=%1 gemqt

move *.gem release
move release\*.gemspec .

:exit

ENDLOCAL

