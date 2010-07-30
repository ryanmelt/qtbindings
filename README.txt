qtbindings
----------
This project provides bindings that allow the QT Gui toolkit to be used from the Ruby Programming language. Overall it is a repackaging of a subset of the KDE bindings ruby and smoke systems into a format that lends itself well to packaging into a Ruby gem.

Goals:
1. To make it easy to install a Qt binding for Ruby on all platforms using RubyGems
2. To maintain an up-to-date binary gem for Windows that is bundled with the latest version of Qt from http://qt.nokia.com
3. To reduce the scope and maintenance of the bindings to only bind to the libraries provided by the Qt SDK.
4. To increase compatibility with non-linux platforms

Install:
gem install qtbindings

This should always work flawlessly on Windows because everything is nicely packaged into a binary gem.  On linux/MacOSX you must make sure you have all the necessary prerequisites installed or the compile will fail. See COMPILING.txt for help on this.

To get help:
Sign up to the kdebindings mailing list at:
https://mail.kde.org/mailman/listinfo/kde-bindings
You can also file tickets here at github for issues specific to the qtbindings gem.

License:
This library is released under the LGPL Version 2.1.
See COPYING.LIB.txt

Disclaimer:
Almost all of this code was written by the great guys who work on the KDE bindings project, particurly Arno Rehn and Richard Dale. I hope to increase the adoption and use of the code that they have written. 

