########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

list(APPEND fmt_COMPONENT_NAMES fmt::fmt-header-only)
list(REMOVE_DUPLICATES fmt_COMPONENT_NAMES)
if(DEFINED fmt_FIND_DEPENDENCY_NAMES)
  list(APPEND fmt_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES fmt_FIND_DEPENDENCY_NAMES)
else()
  set(fmt_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(fmt_PACKAGE_FOLDER_RELEASE "/home/xpr/.conan2/p/fmt243eeaec94394/p")
set(fmt_BUILD_MODULES_PATHS_RELEASE )


set(fmt_INCLUDE_DIRS_RELEASE "${fmt_PACKAGE_FOLDER_RELEASE}/include")
set(fmt_RES_DIRS_RELEASE )
set(fmt_DEFINITIONS_RELEASE "-DFMT_HEADER_ONLY=1")
set(fmt_SHARED_LINK_FLAGS_RELEASE )
set(fmt_EXE_LINK_FLAGS_RELEASE )
set(fmt_OBJECTS_RELEASE )
set(fmt_COMPILE_DEFINITIONS_RELEASE "FMT_HEADER_ONLY=1")
set(fmt_COMPILE_OPTIONS_C_RELEASE )
set(fmt_COMPILE_OPTIONS_CXX_RELEASE )
set(fmt_LIB_DIRS_RELEASE )
set(fmt_BIN_DIRS_RELEASE )
set(fmt_LIBRARY_TYPE_RELEASE UNKNOWN)
set(fmt_IS_HOST_WINDOWS_RELEASE 0)
set(fmt_LIBS_RELEASE )
set(fmt_SYSTEM_LIBS_RELEASE )
set(fmt_FRAMEWORK_DIRS_RELEASE )
set(fmt_FRAMEWORKS_RELEASE )
set(fmt_BUILD_DIRS_RELEASE )
set(fmt_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(fmt_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${fmt_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${fmt_COMPILE_OPTIONS_C_RELEASE}>")
set(fmt_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${fmt_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${fmt_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${fmt_EXE_LINK_FLAGS_RELEASE}>")


set(fmt_COMPONENTS_RELEASE fmt::fmt-header-only)
########### COMPONENT fmt::fmt-header-only VARIABLES ############################################

set(fmt_fmt_fmt-header-only_INCLUDE_DIRS_RELEASE "${fmt_PACKAGE_FOLDER_RELEASE}/include")
set(fmt_fmt_fmt-header-only_LIB_DIRS_RELEASE )
set(fmt_fmt_fmt-header-only_BIN_DIRS_RELEASE )
set(fmt_fmt_fmt-header-only_LIBRARY_TYPE_RELEASE UNKNOWN)
set(fmt_fmt_fmt-header-only_IS_HOST_WINDOWS_RELEASE 0)
set(fmt_fmt_fmt-header-only_RES_DIRS_RELEASE )
set(fmt_fmt_fmt-header-only_DEFINITIONS_RELEASE "-DFMT_HEADER_ONLY=1")
set(fmt_fmt_fmt-header-only_OBJECTS_RELEASE )
set(fmt_fmt_fmt-header-only_COMPILE_DEFINITIONS_RELEASE "FMT_HEADER_ONLY=1")
set(fmt_fmt_fmt-header-only_COMPILE_OPTIONS_C_RELEASE "")
set(fmt_fmt_fmt-header-only_COMPILE_OPTIONS_CXX_RELEASE "")
set(fmt_fmt_fmt-header-only_LIBS_RELEASE )
set(fmt_fmt_fmt-header-only_SYSTEM_LIBS_RELEASE )
set(fmt_fmt_fmt-header-only_FRAMEWORK_DIRS_RELEASE )
set(fmt_fmt_fmt-header-only_FRAMEWORKS_RELEASE )
set(fmt_fmt_fmt-header-only_DEPENDENCIES_RELEASE )
set(fmt_fmt_fmt-header-only_SHARED_LINK_FLAGS_RELEASE )
set(fmt_fmt_fmt-header-only_EXE_LINK_FLAGS_RELEASE )
set(fmt_fmt_fmt-header-only_NO_SONAME_MODE_RELEASE FALSE)

# COMPOUND VARIABLES
set(fmt_fmt_fmt-header-only_LINKER_FLAGS_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${fmt_fmt_fmt-header-only_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${fmt_fmt_fmt-header-only_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${fmt_fmt_fmt-header-only_EXE_LINK_FLAGS_RELEASE}>
)
set(fmt_fmt_fmt-header-only_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${fmt_fmt_fmt-header-only_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${fmt_fmt_fmt-header-only_COMPILE_OPTIONS_C_RELEASE}>")