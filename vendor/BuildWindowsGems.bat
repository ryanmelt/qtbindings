:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Builds Windows 64-bit gems for Windows
:: Usage: BuildWindowsGems VERSION
::
:: Make sure you have installed the following before running:
::   a. Windows SDK for Windows version you are on
::   b. Cmake
::   c. The 64-bit versions of msys2 for Ruby 2.6
::   d. Qt built with msys2 for 64-bit Ruby 2.6
::      See BuildQt4Win64Ruby24.bat
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
set PERL_PATH=C:\Strawberry\perl\bin

cd !QT_PATH!
copy "!MINGW_PATH!\bin\libgcc_s_seh-1.dll" bin
copy "!MINGW_PATH!\bin\libstdc++-6.dll" bin
copy "!MINGW_PATH!\bin\libwinpthread-1.dll" bin
set INCLUDE=!MINGW_PATH!\x86_64-w64-mingw32\include;
set LIB=!MINGW_PATH!\x86_64-w64-mingw32\lib;
set PATH=!MINGW_PATH!\bin;!QT_PATH!;!QT_PATH!\bin;!PERL_PATH!
echo !PATH!
call configure -opensource -confirm-license -release -platform win32-g++-4.6 -opengl desktop -webkit -openssl -qt-style-windowsxp -qt-style-windowsvista -I C:\OpenSSL-Win64\include -L C:\OpenSSL-Win64 -nomake examples -nomake demos
call make clean
jom

:: Go back to where we started
cd "%~dp0"
cd ..
mkdir release

:: Cleanup

set QTBINDINGS_QT_PATH=!QT_PATH!
set PATH=!CMAKE_PATH!;!MINGW_PATH!\bin;!QT_PATH!\bin;!RUBY24_64_PATH!\bin
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

