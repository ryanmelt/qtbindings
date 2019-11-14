:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Builds Windows 64-bit gems for Windows
:: Usage: BuildWindowsGems VERSION
::
:: Make sure you have installed the following before running:
::   a. Windows SDK for Windows version you are on
::   b. Cmake
::   c. The 64-bit versions of msys2 for Ruby 2.6
::   d. Qt built with msys2 for 64-bit Ruby 2.6
::      See BuildQt4Win64.bat
::   e. Ruby version 2.4, 2.5, 2.6 64-bit version
::   f. Update all the paths below to your installations
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo on
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

IF [%1]==[] (
  @echo "Usage: BuildWindowsGems VERSION"
  goto exit
) else (
  set COSMOS_INSTALL=%~1
)

set CMAKE_PATH="C:\Program Files\CMake\bin"
set QT_PATH=C:\Qt\4.8.6
set RUBY24_64_PATH=C:\Ruby24-x64
set RUBY25_64_PATH=C:\Ruby25-x64
set RUBY26_64_PATH=C:\Ruby26-x64
set MINGW_PATH=!RUBY26_64_PATH!\msys64\mingw64
set QTBINDINGS_QT_PATH=!QT_PATH!
set PATH=!CMAKE_PATH!;!MINGW_PATH!\bin;!QT_PATH!\bin;!RUBY26_64_PATH!\bin

cd ..
mkdir release

:: Cleanup
echo.
echo Cleanup
call ruby -e "puts RUBY_VERSION"
echo.
call rake distclean

:: Build 64-bit
echo.
echo Building 64-bit
echo.

set PATH=!RUBY24_64_PATH!\bin;!PATH!
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

set PATH=!RUBY26_64_PATH!\bin;!PATH!
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

