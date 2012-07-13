# - Try to find the QScintilla2 includes and library
# which defines
#
# QSCINTILLA_FOUND - system has QScintilla2
# QSCINTILLA_INCLUDE_DIR - where to find qextscintilla.h
# QSCINTILLA_LIBRARIES - the libraries to link against to use QScintilla
# QSCINTILLA_LIBRARY - where to find the QScintilla library (not for general use)

# copyright (c) 2007 Thomas Moenicke thomas.moenicke@kdemail.net
#
# Redistribution and use is allowed according to the terms of the FreeBSD license.

IF(NOT QT4_FOUND)
    INCLUDE(FindQt4)
ENDIF(NOT QT4_FOUND)

SET(QSCINTILLA_FOUND FALSE)

IF(QT4_FOUND)
    FIND_PATH(QSCINTILLA_INCLUDE_DIR qsciglobal.h
    "${QT_INCLUDE_DIR}/Qsci" /usr/include /usr/include/Qsci
    )

    SET(QSCINTILLA_NAMES ${QSCINTILLA_NAMES} qscintilla2 libqscintilla2)
    FIND_LIBRARY(QSCINTILLA_LIBRARY
        NAMES ${QSCINTILLA_NAMES}
        PATHS ${QT_LIBRARY_DIR}
    )

    IF (QSCINTILLA_LIBRARY AND QSCINTILLA_INCLUDE_DIR)

        SET(QSCINTILLA_LIBRARIES ${QSCINTILLA_LIBRARY})
        SET(QSCINTILLA_FOUND TRUE)

        IF (CYGWIN)
            IF(BUILD_SHARED_LIBS)
            # No need to define QSCINTILLA_USE_DLL here, because it's default for Cygwin.
            ELSE(BUILD_SHARED_LIBS)
            SET (QSCINTILLA_DEFINITIONS -DQSCINTILLA_STATIC)
            ENDIF(BUILD_SHARED_LIBS)
        ENDIF (CYGWIN)

    ENDIF (QSCINTILLA_LIBRARY AND QSCINTILLA_INCLUDE_DIR)
ENDIF(QT4_FOUND)

IF (QSCINTILLA_FOUND)
  IF (NOT QScintilla_FIND_QUIETLY)
    MESSAGE(STATUS "Found QScintilla2: ${QSCINTILLA_LIBRARY}")
  ENDIF (NOT QScintilla_FIND_QUIETLY)
ELSE (QSCINTILLA_FOUND)
  IF (QScintilla_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find QScintilla library")
  ENDIF (QScintilla_FIND_REQUIRED)
ENDIF (QSCINTILLA_FOUND)

MARK_AS_ADVANCED(QSCINTILLA_INCLUDE_DIR QSCINTILLA_LIBRARY)

