########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

list(APPEND mongo-c-driver_COMPONENT_NAMES mongo::bson_static mongo::mongoc_static)
list(REMOVE_DUPLICATES mongo-c-driver_COMPONENT_NAMES)
if(DEFINED mongo-c-driver_FIND_DEPENDENCY_NAMES)
  list(APPEND mongo-c-driver_FIND_DEPENDENCY_NAMES OpenSSL zstd)
  list(REMOVE_DUPLICATES mongo-c-driver_FIND_DEPENDENCY_NAMES)
else()
  set(mongo-c-driver_FIND_DEPENDENCY_NAMES OpenSSL zstd)
endif()
set(OpenSSL_FIND_MODE "NO_MODULE")
set(zstd_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(mongo-c-driver_PACKAGE_FOLDER_RELEASE "/home/xpr/.conan2/p/b/mongo25eba29492c97/p")
set(mongo-c-driver_BUILD_MODULES_PATHS_RELEASE )


set(mongo-c-driver_INCLUDE_DIRS_RELEASE )
set(mongo-c-driver_RES_DIRS_RELEASE )
set(mongo-c-driver_DEFINITIONS_RELEASE )
set(mongo-c-driver_SHARED_LINK_FLAGS_RELEASE )
set(mongo-c-driver_EXE_LINK_FLAGS_RELEASE )
set(mongo-c-driver_OBJECTS_RELEASE )
set(mongo-c-driver_COMPILE_DEFINITIONS_RELEASE )
set(mongo-c-driver_COMPILE_OPTIONS_C_RELEASE )
set(mongo-c-driver_COMPILE_OPTIONS_CXX_RELEASE )
set(mongo-c-driver_LIB_DIRS_RELEASE "${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/lib")
set(mongo-c-driver_BIN_DIRS_RELEASE )
set(mongo-c-driver_LIBRARY_TYPE_RELEASE STATIC)
set(mongo-c-driver_IS_HOST_WINDOWS_RELEASE 0)
set(mongo-c-driver_LIBS_RELEASE )
set(mongo-c-driver_SYSTEM_LIBS_RELEASE resolv m pthread rt)
set(mongo-c-driver_FRAMEWORK_DIRS_RELEASE )
set(mongo-c-driver_FRAMEWORKS_RELEASE )
set(mongo-c-driver_BUILD_DIRS_RELEASE )
set(mongo-c-driver_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(mongo-c-driver_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${mongo-c-driver_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${mongo-c-driver_COMPILE_OPTIONS_C_RELEASE}>")
set(mongo-c-driver_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mongo-c-driver_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mongo-c-driver_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mongo-c-driver_EXE_LINK_FLAGS_RELEASE}>")


set(mongo-c-driver_COMPONENTS_RELEASE mongo::bson_static mongo::mongoc_static)
########### COMPONENT mongo::mongoc_static VARIABLES ############################################

set(mongo-c-driver_mongo_mongoc_static_INCLUDE_DIRS_RELEASE )
set(mongo-c-driver_mongo_mongoc_static_LIB_DIRS_RELEASE "${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/lib")
set(mongo-c-driver_mongo_mongoc_static_BIN_DIRS_RELEASE )
set(mongo-c-driver_mongo_mongoc_static_LIBRARY_TYPE_RELEASE STATIC)
set(mongo-c-driver_mongo_mongoc_static_IS_HOST_WINDOWS_RELEASE 0)
set(mongo-c-driver_mongo_mongoc_static_RES_DIRS_RELEASE )
set(mongo-c-driver_mongo_mongoc_static_DEFINITIONS_RELEASE )
set(mongo-c-driver_mongo_mongoc_static_OBJECTS_RELEASE )
set(mongo-c-driver_mongo_mongoc_static_COMPILE_DEFINITIONS_RELEASE )
set(mongo-c-driver_mongo_mongoc_static_COMPILE_OPTIONS_C_RELEASE "")
set(mongo-c-driver_mongo_mongoc_static_COMPILE_OPTIONS_CXX_RELEASE "")
set(mongo-c-driver_mongo_mongoc_static_LIBS_RELEASE )
set(mongo-c-driver_mongo_mongoc_static_SYSTEM_LIBS_RELEASE resolv)
set(mongo-c-driver_mongo_mongoc_static_FRAMEWORK_DIRS_RELEASE )
set(mongo-c-driver_mongo_mongoc_static_FRAMEWORKS_RELEASE )
set(mongo-c-driver_mongo_mongoc_static_DEPENDENCIES_RELEASE mongo::bson_static openssl::openssl zstd::libzstd_static)
set(mongo-c-driver_mongo_mongoc_static_SHARED_LINK_FLAGS_RELEASE )
set(mongo-c-driver_mongo_mongoc_static_EXE_LINK_FLAGS_RELEASE )
set(mongo-c-driver_mongo_mongoc_static_NO_SONAME_MODE_RELEASE FALSE)

# COMPOUND VARIABLES
set(mongo-c-driver_mongo_mongoc_static_LINKER_FLAGS_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mongo-c-driver_mongo_mongoc_static_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mongo-c-driver_mongo_mongoc_static_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mongo-c-driver_mongo_mongoc_static_EXE_LINK_FLAGS_RELEASE}>
)
set(mongo-c-driver_mongo_mongoc_static_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${mongo-c-driver_mongo_mongoc_static_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${mongo-c-driver_mongo_mongoc_static_COMPILE_OPTIONS_C_RELEASE}>")
########### COMPONENT mongo::bson_static VARIABLES ############################################

set(mongo-c-driver_mongo_bson_static_INCLUDE_DIRS_RELEASE )
set(mongo-c-driver_mongo_bson_static_LIB_DIRS_RELEASE "${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/lib")
set(mongo-c-driver_mongo_bson_static_BIN_DIRS_RELEASE )
set(mongo-c-driver_mongo_bson_static_LIBRARY_TYPE_RELEASE STATIC)
set(mongo-c-driver_mongo_bson_static_IS_HOST_WINDOWS_RELEASE 0)
set(mongo-c-driver_mongo_bson_static_RES_DIRS_RELEASE )
set(mongo-c-driver_mongo_bson_static_DEFINITIONS_RELEASE )
set(mongo-c-driver_mongo_bson_static_OBJECTS_RELEASE )
set(mongo-c-driver_mongo_bson_static_COMPILE_DEFINITIONS_RELEASE )
set(mongo-c-driver_mongo_bson_static_COMPILE_OPTIONS_C_RELEASE "")
set(mongo-c-driver_mongo_bson_static_COMPILE_OPTIONS_CXX_RELEASE "")
set(mongo-c-driver_mongo_bson_static_LIBS_RELEASE )
set(mongo-c-driver_mongo_bson_static_SYSTEM_LIBS_RELEASE m pthread rt)
set(mongo-c-driver_mongo_bson_static_FRAMEWORK_DIRS_RELEASE )
set(mongo-c-driver_mongo_bson_static_FRAMEWORKS_RELEASE )
set(mongo-c-driver_mongo_bson_static_DEPENDENCIES_RELEASE )
set(mongo-c-driver_mongo_bson_static_SHARED_LINK_FLAGS_RELEASE )
set(mongo-c-driver_mongo_bson_static_EXE_LINK_FLAGS_RELEASE )
set(mongo-c-driver_mongo_bson_static_NO_SONAME_MODE_RELEASE FALSE)

# COMPOUND VARIABLES
set(mongo-c-driver_mongo_bson_static_LINKER_FLAGS_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mongo-c-driver_mongo_bson_static_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mongo-c-driver_mongo_bson_static_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mongo-c-driver_mongo_bson_static_EXE_LINK_FLAGS_RELEASE}>
)
set(mongo-c-driver_mongo_bson_static_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${mongo-c-driver_mongo_bson_static_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${mongo-c-driver_mongo_bson_static_COMPILE_OPTIONS_C_RELEASE}>")