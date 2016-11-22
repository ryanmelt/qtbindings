rmdir /s /q bin
mkdir bin
copy "C:\Devkit64\mingw\bin\libgcc_s_sjlj-1.dll" bin
copy "C:\Devkit64\mingw\bin\libstdc++-6.dll" bin
copy "C:\Devkit64\mingw\bin\libwinpthread-1.dll" bin
set INCLUDE=C:\Devkit64\mingw\x86_64-w64-mingw32\include;
set LIB=C:\Devkit64\mingw\x86_64-w64-mingw32\lib;
set PATH=C:\Devkit64\mingw\bin;%PATH%
call configure -opensource -confirm-license -release -platform win32-g++-4.6 -opengl desktop -webkit -openssl -qt-style-windowsxp -qt-style-windowsvista -I C:\OpenSSL-Win64\include -L C:\OpenSSL-Win64 -nomake examples -nomake demos
jom
