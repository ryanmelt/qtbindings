@echo on
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

set CMAKE_PATH="C:\Program Files\CMake\bin"
set QT_PATH=C:\Qt\4.8.6
set MINGW_PATH=C:\Ruby26-x64\msys64\mingw64
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
