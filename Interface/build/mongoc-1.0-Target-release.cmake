# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(mongo-c-driver_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(mongo-c-driver_FRAMEWORKS_FOUND_RELEASE "${mongo-c-driver_FRAMEWORKS_RELEASE}" "${mongo-c-driver_FRAMEWORK_DIRS_RELEASE}")

set(mongo-c-driver_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET mongo-c-driver_DEPS_TARGET)
    add_library(mongo-c-driver_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET mongo-c-driver_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${mongo-c-driver_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${mongo-c-driver_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:mongo::bson_shared>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### mongo-c-driver_DEPS_TARGET to all of them
conan_package_library_targets("${mongo-c-driver_LIBS_RELEASE}"    # libraries
                              "${mongo-c-driver_LIB_DIRS_RELEASE}" # package_libdir
                              "${mongo-c-driver_BIN_DIRS_RELEASE}" # package_bindir
                              "${mongo-c-driver_LIBRARY_TYPE_RELEASE}"
                              "${mongo-c-driver_IS_HOST_WINDOWS_RELEASE}"
                              mongo-c-driver_DEPS_TARGET
                              mongo-c-driver_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "mongo-c-driver"    # package_name
                              "${mongo-c-driver_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${mongo-c-driver_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## COMPONENTS TARGET PROPERTIES Release ########################################

    ########## COMPONENT mongo::mongoc_shared #############

        set(mongo-c-driver_mongo_mongoc_shared_FRAMEWORKS_FOUND_RELEASE "")
        conan_find_apple_frameworks(mongo-c-driver_mongo_mongoc_shared_FRAMEWORKS_FOUND_RELEASE "${mongo-c-driver_mongo_mongoc_shared_FRAMEWORKS_RELEASE}" "${mongo-c-driver_mongo_mongoc_shared_FRAMEWORK_DIRS_RELEASE}")

        set(mongo-c-driver_mongo_mongoc_shared_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET mongo-c-driver_mongo_mongoc_shared_DEPS_TARGET)
            add_library(mongo-c-driver_mongo_mongoc_shared_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET mongo-c-driver_mongo_mongoc_shared_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_mongoc_shared_FRAMEWORKS_FOUND_RELEASE}>
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_mongoc_shared_SYSTEM_LIBS_RELEASE}>
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_mongoc_shared_DEPENDENCIES_RELEASE}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'mongo-c-driver_mongo_mongoc_shared_DEPS_TARGET' to all of them
        conan_package_library_targets("${mongo-c-driver_mongo_mongoc_shared_LIBS_RELEASE}"
                              "${mongo-c-driver_mongo_mongoc_shared_LIB_DIRS_RELEASE}"
                              "${mongo-c-driver_mongo_mongoc_shared_BIN_DIRS_RELEASE}" # package_bindir
                              "${mongo-c-driver_mongo_mongoc_shared_LIBRARY_TYPE_RELEASE}"
                              "${mongo-c-driver_mongo_mongoc_shared_IS_HOST_WINDOWS_RELEASE}"
                              mongo-c-driver_mongo_mongoc_shared_DEPS_TARGET
                              mongo-c-driver_mongo_mongoc_shared_LIBRARIES_TARGETS
                              "_RELEASE"
                              "mongo-c-driver_mongo_mongoc_shared"
                              "${mongo-c-driver_mongo_mongoc_shared_NO_SONAME_MODE_RELEASE}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET mongo::mongoc_shared
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_mongoc_shared_OBJECTS_RELEASE}>
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_mongoc_shared_LIBRARIES_TARGETS}>
                     )

        if("${mongo-c-driver_mongo_mongoc_shared_LIBS_RELEASE}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET mongo::mongoc_shared
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         mongo-c-driver_mongo_mongoc_shared_DEPS_TARGET)
        endif()

        set_property(TARGET mongo::mongoc_shared APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_mongoc_shared_LINKER_FLAGS_RELEASE}>)
        set_property(TARGET mongo::mongoc_shared APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_mongoc_shared_INCLUDE_DIRS_RELEASE}>)
        set_property(TARGET mongo::mongoc_shared APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_mongoc_shared_LIB_DIRS_RELEASE}>)
        set_property(TARGET mongo::mongoc_shared APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_mongoc_shared_COMPILE_DEFINITIONS_RELEASE}>)
        set_property(TARGET mongo::mongoc_shared APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_mongoc_shared_COMPILE_OPTIONS_RELEASE}>)

    ########## COMPONENT mongo::bson_shared #############

        set(mongo-c-driver_mongo_bson_shared_FRAMEWORKS_FOUND_RELEASE "")
        conan_find_apple_frameworks(mongo-c-driver_mongo_bson_shared_FRAMEWORKS_FOUND_RELEASE "${mongo-c-driver_mongo_bson_shared_FRAMEWORKS_RELEASE}" "${mongo-c-driver_mongo_bson_shared_FRAMEWORK_DIRS_RELEASE}")

        set(mongo-c-driver_mongo_bson_shared_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET mongo-c-driver_mongo_bson_shared_DEPS_TARGET)
            add_library(mongo-c-driver_mongo_bson_shared_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET mongo-c-driver_mongo_bson_shared_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_bson_shared_FRAMEWORKS_FOUND_RELEASE}>
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_bson_shared_SYSTEM_LIBS_RELEASE}>
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_bson_shared_DEPENDENCIES_RELEASE}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'mongo-c-driver_mongo_bson_shared_DEPS_TARGET' to all of them
        conan_package_library_targets("${mongo-c-driver_mongo_bson_shared_LIBS_RELEASE}"
                              "${mongo-c-driver_mongo_bson_shared_LIB_DIRS_RELEASE}"
                              "${mongo-c-driver_mongo_bson_shared_BIN_DIRS_RELEASE}" # package_bindir
                              "${mongo-c-driver_mongo_bson_shared_LIBRARY_TYPE_RELEASE}"
                              "${mongo-c-driver_mongo_bson_shared_IS_HOST_WINDOWS_RELEASE}"
                              mongo-c-driver_mongo_bson_shared_DEPS_TARGET
                              mongo-c-driver_mongo_bson_shared_LIBRARIES_TARGETS
                              "_RELEASE"
                              "mongo-c-driver_mongo_bson_shared"
                              "${mongo-c-driver_mongo_bson_shared_NO_SONAME_MODE_RELEASE}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET mongo::bson_shared
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_bson_shared_OBJECTS_RELEASE}>
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_bson_shared_LIBRARIES_TARGETS}>
                     )

        if("${mongo-c-driver_mongo_bson_shared_LIBS_RELEASE}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET mongo::bson_shared
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         mongo-c-driver_mongo_bson_shared_DEPS_TARGET)
        endif()

        set_property(TARGET mongo::bson_shared APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_bson_shared_LINKER_FLAGS_RELEASE}>)
        set_property(TARGET mongo::bson_shared APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_bson_shared_INCLUDE_DIRS_RELEASE}>)
        set_property(TARGET mongo::bson_shared APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_bson_shared_LIB_DIRS_RELEASE}>)
        set_property(TARGET mongo::bson_shared APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_bson_shared_COMPILE_DEFINITIONS_RELEASE}>)
        set_property(TARGET mongo::bson_shared APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Release>:${mongo-c-driver_mongo_bson_shared_COMPILE_OPTIONS_RELEASE}>)

    ########## AGGREGATED GLOBAL TARGET WITH THE COMPONENTS #####################
    set_property(TARGET mongo::mongoc_shared APPEND PROPERTY INTERFACE_LINK_LIBRARIES mongo::mongoc_shared)
    set_property(TARGET mongo::mongoc_shared APPEND PROPERTY INTERFACE_LINK_LIBRARIES mongo::bson_shared)

########## For the modules (FindXXX)
set(mongo-c-driver_LIBRARIES_RELEASE mongo::mongoc_shared)
