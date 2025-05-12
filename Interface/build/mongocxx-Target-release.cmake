# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(mongo-cxx-driver_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(mongo-cxx-driver_FRAMEWORKS_FOUND_RELEASE "${mongo-cxx-driver_FRAMEWORKS_RELEASE}" "${mongo-cxx-driver_FRAMEWORK_DIRS_RELEASE}")

set(mongo-cxx-driver_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET mongo-cxx-driver_DEPS_TARGET)
    add_library(mongo-cxx-driver_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET mongo-cxx-driver_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${mongo-cxx-driver_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${mongo-cxx-driver_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:mongo::mongoc_shared;mongo::bsoncxx_shared;mongo::bson_shared;Boost::headers>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### mongo-cxx-driver_DEPS_TARGET to all of them
conan_package_library_targets("${mongo-cxx-driver_LIBS_RELEASE}"    # libraries
                              "${mongo-cxx-driver_LIB_DIRS_RELEASE}" # package_libdir
                              "${mongo-cxx-driver_BIN_DIRS_RELEASE}" # package_bindir
                              "${mongo-cxx-driver_LIBRARY_TYPE_RELEASE}"
                              "${mongo-cxx-driver_IS_HOST_WINDOWS_RELEASE}"
                              mongo-cxx-driver_DEPS_TARGET
                              mongo-cxx-driver_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "mongo-cxx-driver"    # package_name
                              "${mongo-cxx-driver_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${mongo-cxx-driver_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## COMPONENTS TARGET PROPERTIES Release ########################################

    ########## COMPONENT mongo::mongocxx_shared #############

        set(mongo-cxx-driver_mongo_mongocxx_shared_FRAMEWORKS_FOUND_RELEASE "")
        conan_find_apple_frameworks(mongo-cxx-driver_mongo_mongocxx_shared_FRAMEWORKS_FOUND_RELEASE "${mongo-cxx-driver_mongo_mongocxx_shared_FRAMEWORKS_RELEASE}" "${mongo-cxx-driver_mongo_mongocxx_shared_FRAMEWORK_DIRS_RELEASE}")

        set(mongo-cxx-driver_mongo_mongocxx_shared_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET mongo-cxx-driver_mongo_mongocxx_shared_DEPS_TARGET)
            add_library(mongo-cxx-driver_mongo_mongocxx_shared_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET mongo-cxx-driver_mongo_mongocxx_shared_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_mongocxx_shared_FRAMEWORKS_FOUND_RELEASE}>
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_mongocxx_shared_SYSTEM_LIBS_RELEASE}>
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_mongocxx_shared_DEPENDENCIES_RELEASE}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'mongo-cxx-driver_mongo_mongocxx_shared_DEPS_TARGET' to all of them
        conan_package_library_targets("${mongo-cxx-driver_mongo_mongocxx_shared_LIBS_RELEASE}"
                              "${mongo-cxx-driver_mongo_mongocxx_shared_LIB_DIRS_RELEASE}"
                              "${mongo-cxx-driver_mongo_mongocxx_shared_BIN_DIRS_RELEASE}" # package_bindir
                              "${mongo-cxx-driver_mongo_mongocxx_shared_LIBRARY_TYPE_RELEASE}"
                              "${mongo-cxx-driver_mongo_mongocxx_shared_IS_HOST_WINDOWS_RELEASE}"
                              mongo-cxx-driver_mongo_mongocxx_shared_DEPS_TARGET
                              mongo-cxx-driver_mongo_mongocxx_shared_LIBRARIES_TARGETS
                              "_RELEASE"
                              "mongo-cxx-driver_mongo_mongocxx_shared"
                              "${mongo-cxx-driver_mongo_mongocxx_shared_NO_SONAME_MODE_RELEASE}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET mongo::mongocxx_shared
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_mongocxx_shared_OBJECTS_RELEASE}>
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_mongocxx_shared_LIBRARIES_TARGETS}>
                     )

        if("${mongo-cxx-driver_mongo_mongocxx_shared_LIBS_RELEASE}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET mongo::mongocxx_shared
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         mongo-cxx-driver_mongo_mongocxx_shared_DEPS_TARGET)
        endif()

        set_property(TARGET mongo::mongocxx_shared APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_mongocxx_shared_LINKER_FLAGS_RELEASE}>)
        set_property(TARGET mongo::mongocxx_shared APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_mongocxx_shared_INCLUDE_DIRS_RELEASE}>)
        set_property(TARGET mongo::mongocxx_shared APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_mongocxx_shared_LIB_DIRS_RELEASE}>)
        set_property(TARGET mongo::mongocxx_shared APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_mongocxx_shared_COMPILE_DEFINITIONS_RELEASE}>)
        set_property(TARGET mongo::mongocxx_shared APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_mongocxx_shared_COMPILE_OPTIONS_RELEASE}>)

    ########## COMPONENT mongo::bsoncxx_shared #############

        set(mongo-cxx-driver_mongo_bsoncxx_shared_FRAMEWORKS_FOUND_RELEASE "")
        conan_find_apple_frameworks(mongo-cxx-driver_mongo_bsoncxx_shared_FRAMEWORKS_FOUND_RELEASE "${mongo-cxx-driver_mongo_bsoncxx_shared_FRAMEWORKS_RELEASE}" "${mongo-cxx-driver_mongo_bsoncxx_shared_FRAMEWORK_DIRS_RELEASE}")

        set(mongo-cxx-driver_mongo_bsoncxx_shared_LIBRARIES_TARGETS "")

        ######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
        if(NOT TARGET mongo-cxx-driver_mongo_bsoncxx_shared_DEPS_TARGET)
            add_library(mongo-cxx-driver_mongo_bsoncxx_shared_DEPS_TARGET INTERFACE IMPORTED)
        endif()

        set_property(TARGET mongo-cxx-driver_mongo_bsoncxx_shared_DEPS_TARGET
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_bsoncxx_shared_FRAMEWORKS_FOUND_RELEASE}>
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_bsoncxx_shared_SYSTEM_LIBS_RELEASE}>
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_bsoncxx_shared_DEPENDENCIES_RELEASE}>
                     )

        ####### Find the libraries declared in cpp_info.component["xxx"].libs,
        ####### create an IMPORTED target for each one and link the 'mongo-cxx-driver_mongo_bsoncxx_shared_DEPS_TARGET' to all of them
        conan_package_library_targets("${mongo-cxx-driver_mongo_bsoncxx_shared_LIBS_RELEASE}"
                              "${mongo-cxx-driver_mongo_bsoncxx_shared_LIB_DIRS_RELEASE}"
                              "${mongo-cxx-driver_mongo_bsoncxx_shared_BIN_DIRS_RELEASE}" # package_bindir
                              "${mongo-cxx-driver_mongo_bsoncxx_shared_LIBRARY_TYPE_RELEASE}"
                              "${mongo-cxx-driver_mongo_bsoncxx_shared_IS_HOST_WINDOWS_RELEASE}"
                              mongo-cxx-driver_mongo_bsoncxx_shared_DEPS_TARGET
                              mongo-cxx-driver_mongo_bsoncxx_shared_LIBRARIES_TARGETS
                              "_RELEASE"
                              "mongo-cxx-driver_mongo_bsoncxx_shared"
                              "${mongo-cxx-driver_mongo_bsoncxx_shared_NO_SONAME_MODE_RELEASE}")


        ########## TARGET PROPERTIES #####################################
        set_property(TARGET mongo::bsoncxx_shared
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_bsoncxx_shared_OBJECTS_RELEASE}>
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_bsoncxx_shared_LIBRARIES_TARGETS}>
                     )

        if("${mongo-cxx-driver_mongo_bsoncxx_shared_LIBS_RELEASE}" STREQUAL "")
            # If the component is not declaring any "cpp_info.components['foo'].libs" the system, frameworks etc are not
            # linked to the imported targets and we need to do it to the global target
            set_property(TARGET mongo::bsoncxx_shared
                         APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                         mongo-cxx-driver_mongo_bsoncxx_shared_DEPS_TARGET)
        endif()

        set_property(TARGET mongo::bsoncxx_shared APPEND PROPERTY INTERFACE_LINK_OPTIONS
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_bsoncxx_shared_LINKER_FLAGS_RELEASE}>)
        set_property(TARGET mongo::bsoncxx_shared APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_bsoncxx_shared_INCLUDE_DIRS_RELEASE}>)
        set_property(TARGET mongo::bsoncxx_shared APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_bsoncxx_shared_LIB_DIRS_RELEASE}>)
        set_property(TARGET mongo::bsoncxx_shared APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_bsoncxx_shared_COMPILE_DEFINITIONS_RELEASE}>)
        set_property(TARGET mongo::bsoncxx_shared APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                     $<$<CONFIG:Release>:${mongo-cxx-driver_mongo_bsoncxx_shared_COMPILE_OPTIONS_RELEASE}>)

    ########## AGGREGATED GLOBAL TARGET WITH THE COMPONENTS #####################
    set_property(TARGET mongo::mongocxx_shared APPEND PROPERTY INTERFACE_LINK_LIBRARIES mongo::mongocxx_shared)
    set_property(TARGET mongo::mongocxx_shared APPEND PROPERTY INTERFACE_LINK_LIBRARIES mongo::bsoncxx_shared)

########## For the modules (FindXXX)
set(mongo-cxx-driver_LIBRARIES_RELEASE mongo::mongocxx_shared)
