rmdir /s /q bin
mkdir bin
copy "C:\msys64\mingw32\bin\libgcc_s_dw2-1.dll" bin
copy "C:\msys64\mingw32\bin\libstdc++-6.dll" bin
copy "C:\msys64\mingw32\bin\libwinpthread-1.dll" bin
set INCLUDE=C:\msys64\mingw32\x86_64-w64-mingw32\include;
set LIB=C:\msys64\mingw32\i686-w64-mingw32\lib;
set PATH=C:\msys64\mingw32\bin;%PATH%
call configure -opensource -confirm-license -release -platform win32-g++-4.6 -opengl desktop -webkit -openssl -qt-style-windowsxp -qt-style-windowsvista -I C:\OpenSSL-Win64\include -L C:\OpenSSL-Win64 -nomake examples -nomake demos
jom
