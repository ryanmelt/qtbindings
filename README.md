# qtbindings - Ruby bindings to QT

[![qtbindings Version](https://badge.fury.io/rb/qtbindings.svg)](https://badge.fury.io/rb/qtbindings)
[![qtbindings-qt Version](https://badge.fury.io/rb/qtbindings-qt.svg)](https://badge.fury.io/rb/qtbindings-qt)
![Ruby](https://github.com/ryanmelt/qtbindings/workflows/Ruby/badge.svg)

Warning: This project is no longer maintained. It only supports Qt4 which the latest linux distributions no longer include in their package repos. No future releases or changes are planned. If you would like to take over, please fork, and make the changes to support Qt5/Qt6. This will be really difficult as the Smoke libraries used in this project do not work well with C++11+. Its been a fun 10 years maintaining this for the Ruby community, but at this point I would recommend using Python if you want to create a modern desktop application using Qt. I'm personally switching to developing web apps using Vue.

Note: The current windows gem (since 4.8.6.4) only works with Ruby 2.4 and Ruby 2.5.  To use Ruby 2.0 to Ruby 2.3 please install version 4.8.6.3

This project provides bindings that allow the QT Gui toolkit to be used from the
Ruby Programming language. Overall it is a repackaging of a subset of the KDE
bindings ruby and smoke systems into a format that lends itself well to
packaging into a Ruby gem.

Goals
-----
1.  To make it easy to install a Qt binding for Ruby on all platforms using RubyGems
2.  To maintain an up-to-date binary gem for Windows that is bundled with the latest version of Qt 4
3.  To reduce the scope and maintenance of the bindings to only bind to the libraries provided by the Qt SDK.
4.  To increase compatibility with non-linux platforms

Note: Qt 4.8.7 and 5.X is currently NOT supported.  
For Ruby 1.9.3 you should use version 4.8.5.2.  
For Ruby 1.8.x you can try installing version 4.8.3.0, however upgrading Ruby is highly recommended.  

Usage Notes
------------
Ruby threading is now fully supported out of the box. All GUI access however must be done
inside the main thread. To support updating the GUI using other threads, use the following function
provided in Qt4.rb:

```ruby
Qt.execute_in_main_thread do # block the main thread
  # GUI code which executes and then allows the main thread to execute
end

Qt.execute_in_main_thread(false) do # don't block the main thread
  # GUI code which executes in parallel with the main thread
end
```

To use Qt plugins (Reading jpgs, etc) on Windows, you should add this line after creating your Qt::Application.

```ruby
Qt::Application.instance.addLibraryPath(Qt::PLUGIN_PATH)
```

Tested Environments
--------------------
Mac OSX 10.13.6 (High Sierra)  
XCode 5 (clang)  
Brew - QT 4.8.6  
CMake 3.10.2
Ruby 2.6.5 - Must be compiled with clang (rvm install <version> --with-gcc=clang)

Windows 7 SP1  
QT SDK 4.8.6-1  
CMake 3.6.3  
Ruby 2.5.7 installed from rubyinstaller.org  

Ubuntu Linux 16.04
QT SDK 4.8.6
Cmake 2.8.5  

Compiling
---------
Compiling qtbindings requires the following prerequisites:

1.  Ruby (Ruby must be compiled with --enable-shared on all platforms and with --with-gcc=clang on OSX)  
    On Windows use the latest from [RubyInstaller](http://rubyinstaller.org/downloads/)  
    You'll need both the 32bit and 64bit installers to make the fat binary gem 
2.  [CMake 3.6.x](https://cmake.org/download)
3.  On Windows get [OpenSSL 1.0.2 x64](http://slproweb.com/products/Win32OpenSSL.html) (not Light)  
    Install with all defaults to C:\OpenSSL-Win64  
4.  [QT 4.8.6](https://download.qt.io/official_releases/qt/4.8/4.8.6/) (mingw version for Windows)  
    On Windows install to C:\Qt\4.8.6-Ruby24 (when installing specify the mingw inside the 32bit DevKit)  
    On Windows install a second copy to C:\Qt\4.8.6-64-Ruby24 (when installing specify the mingw inside the 64bit DevKit)  
    Install [Jom](https://wiki.qt.io/Jom) to C:\Qt\4.8.6-64-Ruby24 (or anywhere in your path)  
5.  gcc 4.x, 5.x, or 6.x (or clang for OSX 10.9)  
    On Windows gcc 4.x is included in the DevKit  

Note for OSX 10.9.  The default compiler has changed from gcc to clang.   All libraries need to be compiled with clang or you will get segfaults.  This includes ruby, qt, and qtbindings.  *** rvm does not compile with clang by default.  You must add --with-gcc=clang when installing a version of ruby ***

Additionally: all of the operating system prequisites for compiling, window system development, opengl, etc must be installed.

Rakefile
--------
Perform the following steps to build the gem on Unix or Mac:

1. `rake VERSION=4.8.x.y gem`  
    Where the x is the subversion of QT and y is the patch level of qtbindings

Perform the following steps to build the gem on Windows:

1. cd vendor
2. Edit BuildWindowsGems.bat to ensure all paths are correct
3. Run: BuildWindowsGems.bat

Note: The gem is built two times to create two FAT binaries which will work on Ruby 2.4 and higher (x64/x86).

After building the gem, verify the examples work by running:

1. `rake examples`

Operating Systems Notes:

Debian Linux
------------

1. The following should get you the packages you need:

```
sudo aptitude install build-essential bison openssl libreadline5 \
  libreadline-dev curl git-core zlib1g zlib1g-dev libssl-dev vim \
  libsqlite3-0 libsqlite3-dev sqlite3 \
  libxml2-dev git-core subversion autoconf xorg-dev libgl1-mesa-dev \
  libglu1-mesa-dev ruby-dev libqt4-dev
```

Fedora Linux
------------

You will also need these packages:
```
sudo yum install qtwebkit-devel qtwebkit
```

Mac OSX Snow Leopard
-----------------------

1. XCode
2. Brew (http://mxcl.github.com/homebrew/)  
   Install qt with `brew install qt`

Windows - Note: Only necessary for debugging (binary gem available)
--------
Qt should be rebuilt using Devkit before building.

1. Run vendor\PatchQt4.8.6Ruby24.bat
2. Copy vendor\BuildQt4Win32Ruby24.bat to C:\Qt\4.8.6-Ruby24 and run it
3. Copy vendor\BuildQt4Win64Ruby24.bat to C:\Qt\4.8.6-64-Ruby24 and run it

Install
------
On linux/MacOSX you must make sure you have all the necessary prerequisites
installed or the compile will fail.

    gem install qtbindings

This should always work flawlessly on Windows because everything is nicely packaged into a binary gem. However, the gem is very large ~90MB, so please be patient while gem downloads the file.

To get help:
You can file tickets here at github for issues specific to the qtbindings gem.

License:
This library is released under the LGPL Version 2.1.
See COPYING.LIB.txt

Contributing:
Fork the project and submit pull requests.

Disclaimer:
Almost all of this code was written by the guys who worked on the KDE bindings project, particurly Arno Rehn and Richard Dale. This project aims to increase the adoption and use of the code that they have written.

