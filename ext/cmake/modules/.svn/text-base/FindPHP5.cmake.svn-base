# - Find PHP5
# This module finds if PHP5 is installed and determines where the include files
# and libraries are. It also determines what the name of the library is. This
# code sets the following variables:
#
#  PHP5_INCLUDE_PATH       = path to where php.h can be found
#  PHP5_EXECUTABLE         = full path to the php4 binary
#
#  file is derived from FindPHP4.cmake
#

SET(PHP5_FOUND "NO")

SET(PHP5_POSSIBLE_INCLUDE_PATHS
  /usr/include/php5
  /usr/local/include/php5
  /usr/include/php
  /usr/local/include/php
  /usr/local/apache/php
  )

SET(PHP5_POSSIBLE_LIB_PATHS
  /usr/lib
  )

#FIND_PATH(PHP5_FOUND_INCLUDE_PATH main/php.h
#  ${PHP5_POSSIBLE_INCLUDE_PATHS})
#
#IF(PHP5_FOUND_INCLUDE_PATH)
#  SET(php5_paths "${PHP5_POSSIBLE_INCLUDE_PATHS}")
#  FOREACH(php5_path Zend main TSRM)
#    SET(php5_paths ${php5_paths} "${PHP5_FOUND_INCLUDE_PATH}/${php5_path}")
#  ENDFOREACH(php5_path Zend main TSRM)
#  SET(PHP5_INCLUDE_PATH "${php5_paths}" INTERNAL "PHP5 include paths")
#ENDIF(PHP5_FOUND_INCLUDE_PATH)

FIND_PROGRAM(PHP5_EXECUTABLE
  NAMES php5 php
  PATHS
  /usr/local/bin
  )

MARK_AS_ADVANCED(
  PHP5_EXECUTABLE
  PHP5_FOUND_INCLUDE_PATH
  )

IF(APPLE)
# this is a hack for now
#  SET(CMAKE_SHARED_MODULE_CREATE_C_FLAGS 
#   "${CMAKE_SHARED_MODULE_CREATE_C_FLAGS} -Wl,-flat_namespace")
  SET(CMAKE_SHARED_MODULE_CREATE_C_FLAGS 
   "-Wl,-flat_namespace")
  FOREACH(symbol
    __efree
    __emalloc
    __estrdup
    __object_init_ex
    __zend_get_parameters_array_ex
    __zend_get_parameters_array
    __zend_list_find
    __zval_copy_ctor
    _add_property_zval_ex
    _alloc_globals
    _compiler_globals
    _convert_to_double
    _convert_to_long
    _zend_error
    _zend_hash_find
    _zend_register_internal_class_ex
    _zend_register_list_destructors_ex
    _zend_register_resource
    _zend_rsrc_list_get_rsrc_type
    _zend_wrong_param_count
    _zval_used_for_init
    _zend_register_list_destructors_ex
    _zend_hash_exists
 __zend_hash_init_ex
 _php_info_print_table_header
 _zend_hash_destroy
 __ecalloc
 _zend_parse_parameters
 _php_sprintf
 _php_info_print_table_start
 _zend_hash_apply_with_arguments
 __estrndup
 _zend_fetch_class
 _zend_register_internal_class
 _zend_objects_get_address
 _zend_get_std_object_handlers
 _zend_read_property
 _zend_register_ini_entries
 __erealloc
 _zend_hash_internal_pointer_reset_ex
 _convert_to_null
 __convert_to_string
 _php_info_print_table_end
 _executor_globals
 __safe_emalloc
 _zend_str_tolower_copy
 __zval_copy_ctor_func
 _zend_hash_get_current_key_ex
 _zend_hash_num_elements
 _display_ini_entries
 _zend_ini_string
 _zval_update_constant
 _zend_do_inheritance
 __zval_ptr_dtor
 _zend_opcode_handlers
 _zval_add_ref
 _zend_hash_get_current_data_ex
 _zend_get_class_entry
 _zend_hash_move_forward_ex
 _zend_hash_get_current_key_type_ex
 _call_user_function
_zend_object_store_get_object_by_handle
_add_next_index_string
__array_init
__zend_hash_init
__zval_ptr_dtor_wrapper
__zval_dtor_func
    )
    SET(CMAKE_SHARED_MODULE_CREATE_C_FLAGS 
      "${CMAKE_SHARED_MODULE_CREATE_C_FLAGS},-U,${symbol}")
  ENDFOREACH(symbol)
ENDIF(APPLE)

IF( NOT PHP5_CONFIG_EXECUTABLE )
FIND_PROGRAM(PHP5_CONFIG_EXECUTABLE
  NAMES php5-config php-config
  )
ENDIF( NOT PHP5_CONFIG_EXECUTABLE )

IF(PHP5_CONFIG_EXECUTABLE)
  EXECUTE_PROCESS(COMMAND ${PHP5_CONFIG_EXECUTABLE} --version
    OUTPUT_VARIABLE PHP5_VERSION)
  STRING(REPLACE "\n" "" PHP5_VERSION "${PHP5_VERSION}")

  EXECUTE_PROCESS(COMMAND ${PHP5_CONFIG_EXECUTABLE} --extension-dir
    OUTPUT_VARIABLE PHP5_EXTENSION_DIR)
  STRING(REPLACE "\n" "" PHP5_EXTENSION_DIR "${PHP5_EXTENSION_DIR}")

  EXECUTE_PROCESS(COMMAND ${PHP5_CONFIG_EXECUTABLE} --includes
    OUTPUT_VARIABLE PHP5_INCLUDES)
  STRING(REPLACE "-I" "" PHP5_INCLUDES "${PHP5_INCLUDES}")
  STRING(REPLACE " " ";" PHP5_INCLUDES "${PHP5_INCLUDES}")
  STRING(REPLACE "\n" "" PHP5_INCLUDES "${PHP5_INCLUDES}")
  LIST(GET PHP5_INCLUDES 0 PHP5_INCLUDE_DIR)

  set(PHP5_MAIN_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/main)
  set(PHP5_TSRM_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/TSRM)
  set(PHP5_ZEND_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/Zend)
  set(PHP5_REGEX_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/regex)
  set(PHP5_EXT_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/ext)
  set(PHP5_DATE_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/ext/date/lib)
  set(PHP5_STANDARD_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/ext/standard)

  MESSAGE(STATUS ${PHP5_MAIN_INCLUDE_DIR})

  IF(PHP5_VERSION LESS 5)
    MESSAGE(FATAL_ERROR "PHP version is not 5 or later")
  ENDIF(PHP5_VERSION LESS 5)

  IF(PHP5_EXECUTABLE AND PHP5_INCLUDES)
    set(PHP5_FOUND "yes")
    MESSAGE(STATUS "Found PHP5-Version ${PHP5_VERSION} (using ${PHP5_CONFIG_EXECUTABLE})")
  ENDIF(PHP5_EXECUTABLE AND PHP5_INCLUDES)

  FIND_PROGRAM(PHPUNIT_EXECUTABLE
    NAMES phpunit phpunit2
    PATHS
    /usr/local/bin
  )

  IF(PHPUNIT_EXECUTABLE)
    MESSAGE(STATUS "Found phpunit: ${PHPUNIT_EXECUTABLE}")
  ENDIF(PHPUNIT_EXECUTABLE)

ENDIF(PHP5_CONFIG_EXECUTABLE)
