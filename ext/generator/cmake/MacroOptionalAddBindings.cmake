# Copyright (c) 2010 Maciej Mrozowski <reavertm@gmail.com>
#
# Redistribution and use is allowed according to the terms of the GPL license.

# Conditionally enable bindings.
# Pass -DDISABLE_<component_name>=ON to disable certain binding even if its dependencies are found.
# CMake project needs to be set before using this macro.
# Macro sets following variables:
#     ${CMAKE_PROJECT_NAME}_ENABLED - list of enabled bindings
#     ${CMAKE_PROJECT_NAME}_DISABLED - list of disabled bindings
# Usage:
#     macro_optional_add_bindings(<component_found> <component_name> <subdir1> [<subdir2> ...])
#
# Example:
#     project(SMOKE)
#     [...]
#     macro_optional_add_bindings(NEPOMUK_FOUND "Nepomuk" nepomuk nepomukquery)
#     [...]
#     macro_display_bindings_log()
macro(MACRO_OPTIONAL_ADD_BINDINGS _component_found _component_name)
    get_property(_PREFIX VARIABLE PROPERTY PROJECT_NAME)
    if(${_component_found} AND NOT DISABLE_${_component_name})
        foreach(_subdir ${ARGN})
            add_subdirectory(${_subdir})
        endforeach(_subdir ${ARGN})
        list(APPEND ${_PREFIX}_ENABLED ${_component_name})
    else(${_component_found} AND NOT DISABLE_${_component_name})
        list(APPEND ${_PREFIX}_DISABLED ${_component_name})
    endif(${_component_found} AND NOT DISABLE_${_component_name})
    set(_PREFIX)
endmacro(MACRO_OPTIONAL_ADD_BINDINGS)

# Show bindings summary
# Usage:
#     macro_display_bindings_log()
macro(MACRO_DISPLAY_BINDINGS_LOG)
    get_property(_PREFIX VARIABLE PROPERTY PROJECT_NAME)
    if (${_PREFIX}_ENABLED)
        list(SORT ${_PREFIX}_ENABLED)
    endif (${_PREFIX}_ENABLED)
    if (${_PREFIX}_DISABLED)
        list(SORT ${_PREFIX}_DISABLED)
    endif (${_PREFIX}_DISABLED)
    message(STATUS "Build ${_PREFIX} bindings: ${${_PREFIX}_ENABLED}")
    message(STATUS "Skip ${_PREFIX} bindings: ${${_PREFIX}_DISABLED}")
    set(_PREFIX)
endmacro(MACRO_DISPLAY_BINDINGS_LOG)
