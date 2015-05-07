set INCLUDE=C:\Devkit64\mingw\x86_64-w64-mingw32\include;
set LIB=C:\Devkit64\mingw\x86_64-w64-mingw32\lib;
set PATH=C:\Devkit64\mingw\bin;%PATH%
Configure -opensource -confirm-license -platform win32-g++-4.6 -opengl desktop -webkit -openssl -native-gestures -qt-style-windowsxp -qt-style-windowsvista -I C:\OpenSSL-Win64\include -L C:\OpenSSL-Win64
