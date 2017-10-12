@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

set DEVKIT_32_PATH=C:\Devkit32
set DEVKIT_64_PATH=C:\Devkit64
set MSYS64_32_PATH=C:\msys64
set MSYS64_64_PATH=C:\msys64
set QT_32_PATH=C:\Qt\4.8.6
set Qt_64_PATH=C:\Qt\4.8.6-x64
set QT_32_RUBY24_PATH=C:\Qt\4.8.6-Ruby24
set Qt_64_RUBY24_PATH=C:\Qt\4.8.6-64-Ruby24
set RUBY22_32_PATH=C:\Ruby226
set RUBY22_64_PATH=C:\Ruby226-x64
set RUBY23_32_PATH=C:\Ruby233
set RUBY23_64_PATH=C:\Ruby233-x64
set RUBY24_32_PATH=C:\Ruby242
set RUBY24_64_PATH=C:\Ruby242-x64
set CMAKE_PATH=C:\Program Files (x86)\CMake 2.8

:: Down to the main directory
cd ..

set PATH=!CMAKE_PATH!\bin;%PATH%

:: 32-bit version

:: Cleanup
set QTBINDINGS_QT_PATH=!QT_32_PATH!
set PATH=!DEVKIT_32_PATH!\mingw\bin;!QT_32_PATH!\bin;%PATH%
set PATH=!RUBY22_32_PATH!\bin;%PATH%
call rake distclean
set PATH=!RUBY23_32_PATH!\bin;%PATH%
call rake distclean
set QTBINDINGS_QT_PATH=!QT_32_RUBY24_PATH!
set PATH=!MSYS64_32_PATH!\mingw32\bin;!QT_32_RUBY24_PATH!\bin;%PATH%
set PATH=!RUBY24_32_PATH!\bin;%PATH%
call rake distclean

:: 64-bit version

:: Cleanup
set QTBINDINGS_QT_PATH=!QT_64_PATH!
set PATH=!DEVKIT_64_PATH!\mingw\bin;!QT_64_PATH!\bin;%PATH%
set PATH=!RUBY22_64_PATH!\bin;%PATH%
call rake distclean
set PATH=!RUBY23_64_PATH!\bin;%PATH%
call rake distclean
set QTBINDINGS_QT_PATH=!QT_64_RUBY24_PATH!
set PATH=!MSYS64_64_PATH!\mingw64\bin;!QT_64_RUBY24_PATH!\bin;%PATH%
set PATH=!RUBY24_64_PATH!\bin;%PATH%
call rake distclean

:exit

