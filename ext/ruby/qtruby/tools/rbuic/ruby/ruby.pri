INCLUDEPATH += $$PWD

DEFINES += QT_UIC_RUBY_GENERATOR

# Input
HEADERS += $$PWD/rbextractimages.h \
           $$PWD/rbwritedeclaration.h \
           $$PWD/rbwriteicondata.h \
           $$PWD/rbwriteicondeclaration.h \
           $$PWD/rbwriteiconinitialization.h \
           $$PWD/rbwriteinitialization.h

SOURCES += $$PWD/rbextractimages.cpp \
           $$PWD/rbwritedeclaration.cpp \
           $$PWD/rbwriteicondata.cpp \
           $$PWD/rbwriteicondeclaration.cpp \
           $$PWD/rbwriteiconinitialization.cpp \
           $$PWD/rbwriteinitialization.cpp
