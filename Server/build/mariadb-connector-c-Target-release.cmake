# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(mariadb-connector-c_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(mariadb-connector-c_FRAMEWORKS_FOUND_RELEASE "${mariadb-connector-c_FRAMEWORKS_RELEASE}" "${mariadb-connector-c_FRAMEWORK_DIRS_RELEASE}")

set(mariadb-connector-c_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET mariadb-connector-c_DEPS_TARGET)
    add_library(mariadb-connector-c_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET mariadb-connector-c_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${mariadb-connector-c_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${mariadb-connector-c_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:CURL::libcurl;openssl::openssl;zstd::libzstd_static>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### mariadb-connector-c_DEPS_TARGET to all of them
conan_package_library_targets("${mariadb-connector-c_LIBS_RELEASE}"    # libraries
                              "${mariadb-connector-c_LIB_DIRS_RELEASE}" # package_libdir
                              "${mariadb-connector-c_BIN_DIRS_RELEASE}" # package_bindir
                              "${mariadb-connector-c_LIBRARY_TYPE_RELEASE}"
                              "${mariadb-connector-c_IS_HOST_WINDOWS_RELEASE}"
                              mariadb-connector-c_DEPS_TARGET
                              mariadb-connector-c_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "mariadb-connector-c"    # package_name
                              "${mariadb-connector-c_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${mariadb-connector-c_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET mariadb-connector-c::mariadb-connector-c
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${mariadb-connector-c_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${mariadb-connector-c_LIBRARIES_TARGETS}>
                 )

    if("${mariadb-connector-c_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET mariadb-connector-c::mariadb-connector-c
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     mariadb-connector-c_DEPS_TARGET)
    endif()

    set_property(TARGET mariadb-connector-c::mariadb-connector-c
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${mariadb-connector-c_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET mariadb-connector-c::mariadb-connector-c
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${mariadb-connector-c_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET mariadb-connector-c::mariadb-connector-c
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${mariadb-connector-c_LIB_DIRS_RELEASE}>)
    set_property(TARGET mariadb-connector-c::mariadb-connector-c
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${mariadb-connector-c_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET mariadb-connector-c::mariadb-connector-c
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${mariadb-connector-c_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(mariadb-connector-c_LIBRARIES_RELEASE mariadb-connector-c::mariadb-connector-c)
