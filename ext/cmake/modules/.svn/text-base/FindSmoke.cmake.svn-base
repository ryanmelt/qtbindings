# Find smoke libraries.
#
# Use:
#
# find_package(Smoke [REQUIRED] COMPONENTS QtCore QtGui <other components>)
#
# Defines:
#
# SMOKE_INCLUDE_DIR                 Directory in which smoke.h is located
# SMOKE_<component>_INCLUDE_DIR     Directory in which to find smoke/<component>_smoke.h
# SMOKE_<component>_LIBRARY         Library for the smoke lib
#
# Copyright (c) 2010, Arno Rehn <arno@arnorehn.de>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

#####################
# utility functions #
#####################

function (_print type message)
    if (NOT Smoke_FIND_QUIETLY)
        message (${type} "${message}")
    endif (NOT Smoke_FIND_QUIETLY)
endfunction (_print type message)


##############################
# find individual smoke libs #
##############################

macro (find_smoke_component name)
    string(TOUPPER ${name} uppercase)
    string(TOLOWER ${name} lowercase)

    if (NOT SMOKE_${uppercase}_FOUND)
        set (SMOKE_${uppercase}_FOUND FALSE CACHE INTERNAL "")

        find_path(SMOKE_${uppercase}_INCLUDE_DIR smoke/${lowercase}_smoke.h)
        find_library(SMOKE_${uppercase}_LIBRARY smoke${lowercase})

        if (NOT SMOKE_${uppercase}_INCLUDE_DIR OR NOT SMOKE_${uppercase}_LIBRARY)
            if (Smoke_FIND_REQUIRED)
                _print(FATAL_ERROR "Could not find Smoke${name}")
            else (Smoke_FIND_REQUIRED)
                _print(STATUS "Could not find Smoke${name}")
            endif (Smoke_FIND_REQUIRED)
        else (NOT SMOKE_${uppercase}_INCLUDE_DIR OR NOT SMOKE_${uppercase}_LIBRARY)
            set (SMOKE_${uppercase}_FOUND TRUE CACHE INTERNAL "")
            _print(STATUS "Found Smoke${name}: ${SMOKE_${uppercase}_LIBRARY}")
        endif (NOT SMOKE_${uppercase}_INCLUDE_DIR OR NOT SMOKE_${uppercase}_LIBRARY)

        mark_as_advanced(SMOKE_${uppercase}_INCLUDE_DIR SMOKE_${uppercase}_LIBRARY SMOKE_${uppercase}_FOUND)
    endif (NOT SMOKE_${uppercase}_FOUND)
endmacro (find_smoke_component)

################
# find smoke.h #
################
find_path(SMOKE_INCLUDE_DIR smoke.h)
find_library(SMOKE_BASE_LIBRARY smokebase)

if (NOT SMOKE_INCLUDE_DIR OR NOT SMOKE_BASE_LIBRARY)
    if (Smoke_FIND_REQUIRED)
        _print(FATAL_ERROR "Could not find SMOKE")
    else (Smoke_FIND_REQUIRED)
        _print(STATUS "Could not find SMOKE")
    endif (Smoke_FIND_REQUIRED)
endif (NOT SMOKE_INCLUDE_DIR OR NOT SMOKE_BASE_LIBRARY)

mark_as_advanced(SMOKE_INCLUDE_DIR SMOKE_BASE_LIBRARY)

if (Smoke_FIND_COMPONENTS)
    foreach (component ${Smoke_FIND_COMPONENTS})
        find_smoke_component(${component})
    endforeach(component)
endif (Smoke_FIND_COMPONENTS)
