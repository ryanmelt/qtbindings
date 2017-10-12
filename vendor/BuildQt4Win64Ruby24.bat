rmdir /s /q bin
mkdir bin
copy "C:\msys64\mingw64\bin\libgcc_s_seh-1.dll" bin
copy "C:\msys64\mingw64\bin\libstdc++-6.dll" bin
copy "C:\msys64\mingw64\bin\libwinpthread-1.dll" bin
set INCLUDE=C:\msys64\mingw64\x86_64-w64-mingw32\include;
set LIB=C:\msys64\mingw64\x86_64-w64-mingw32\lib;
set PATH=C:\msys64\mingw64\bin;%PATH%
call configure -opensource -confirm-license -release -platform win32-g++-4.6 -opengl desktop -webkit -openssl -qt-style-windowsxp -qt-style-windowsvista -I C:\OpenSSL-Win64\include -L C:\OpenSSL-Win64 -nomake examples -nomake demos
jom
