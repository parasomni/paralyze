########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

list(APPEND mongo-c-driver_COMPONENT_NAMES mongo::bson_shared mongo::mongoc_shared)
list(REMOVE_DUPLICATES mongo-c-driver_COMPONENT_NAMES)
if(DEFINED mongo-c-driver_FIND_DEPENDENCY_NAMES)
  list(APPEND mongo-c-driver_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES mongo-c-driver_FIND_DEPENDENCY_NAMES)
else()
  set(mongo-c-driver_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(mongo-c-driver_PACKAGE_FOLDER_RELEASE "/home/xpr/.conan2/p/b/mongoae489403a23ff/p")
set(mongo-c-driver_BUILD_MODULES_PATHS_RELEASE )


set(mongo-c-driver_INCLUDE_DIRS_RELEASE "${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/include/libmongoc-1.0"
			"${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/include/libbson-1.0")
set(mongo-c-driver_RES_DIRS_RELEASE )
set(mongo-c-driver_DEFINITIONS_RELEASE )
set(mongo-c-driver_SHARED_LINK_FLAGS_RELEASE )
set(mongo-c-driver_EXE_LINK_FLAGS_RELEASE )
set(mongo-c-driver_OBJECTS_RELEASE )
set(mongo-c-driver_COMPILE_DEFINITIONS_RELEASE )
set(mongo-c-driver_COMPILE_OPTIONS_C_RELEASE )
set(mongo-c-driver_COMPILE_OPTIONS_CXX_RELEASE )
set(mongo-c-driver_LIB_DIRS_RELEASE "${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/lib")
set(mongo-c-driver_BIN_DIRS_RELEASE "${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/bin")
set(mongo-c-driver_LIBRARY_TYPE_RELEASE SHARED)
set(mongo-c-driver_IS_HOST_WINDOWS_RELEASE 0)
set(mongo-c-driver_LIBS_RELEASE mongoc-1.0 bson-1.0)
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


set(mongo-c-driver_COMPONENTS_RELEASE mongo::bson_shared mongo::mongoc_shared)
########### COMPONENT mongo::mongoc_shared VARIABLES ############################################

set(mongo-c-driver_mongo_mongoc_shared_INCLUDE_DIRS_RELEASE "${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/include/libmongoc-1.0")
set(mongo-c-driver_mongo_mongoc_shared_LIB_DIRS_RELEASE "${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/lib")
set(mongo-c-driver_mongo_mongoc_shared_BIN_DIRS_RELEASE "${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/bin")
set(mongo-c-driver_mongo_mongoc_shared_LIBRARY_TYPE_RELEASE SHARED)
set(mongo-c-driver_mongo_mongoc_shared_IS_HOST_WINDOWS_RELEASE 0)
set(mongo-c-driver_mongo_mongoc_shared_RES_DIRS_RELEASE )
set(mongo-c-driver_mongo_mongoc_shared_DEFINITIONS_RELEASE )
set(mongo-c-driver_mongo_mongoc_shared_OBJECTS_RELEASE )
set(mongo-c-driver_mongo_mongoc_shared_COMPILE_DEFINITIONS_RELEASE )
set(mongo-c-driver_mongo_mongoc_shared_COMPILE_OPTIONS_C_RELEASE "")
set(mongo-c-driver_mongo_mongoc_shared_COMPILE_OPTIONS_CXX_RELEASE "")
set(mongo-c-driver_mongo_mongoc_shared_LIBS_RELEASE mongoc-1.0)
set(mongo-c-driver_mongo_mongoc_shared_SYSTEM_LIBS_RELEASE resolv)
set(mongo-c-driver_mongo_mongoc_shared_FRAMEWORK_DIRS_RELEASE )
set(mongo-c-driver_mongo_mongoc_shared_FRAMEWORKS_RELEASE )
set(mongo-c-driver_mongo_mongoc_shared_DEPENDENCIES_RELEASE mongo::bson_shared)
set(mongo-c-driver_mongo_mongoc_shared_SHARED_LINK_FLAGS_RELEASE )
set(mongo-c-driver_mongo_mongoc_shared_EXE_LINK_FLAGS_RELEASE )
set(mongo-c-driver_mongo_mongoc_shared_NO_SONAME_MODE_RELEASE FALSE)

# COMPOUND VARIABLES
set(mongo-c-driver_mongo_mongoc_shared_LINKER_FLAGS_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mongo-c-driver_mongo_mongoc_shared_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mongo-c-driver_mongo_mongoc_shared_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mongo-c-driver_mongo_mongoc_shared_EXE_LINK_FLAGS_RELEASE}>
)
set(mongo-c-driver_mongo_mongoc_shared_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${mongo-c-driver_mongo_mongoc_shared_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${mongo-c-driver_mongo_mongoc_shared_COMPILE_OPTIONS_C_RELEASE}>")
########### COMPONENT mongo::bson_shared VARIABLES ############################################

set(mongo-c-driver_mongo_bson_shared_INCLUDE_DIRS_RELEASE "${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/include/libbson-1.0")
set(mongo-c-driver_mongo_bson_shared_LIB_DIRS_RELEASE "${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/lib")
set(mongo-c-driver_mongo_bson_shared_BIN_DIRS_RELEASE "${mongo-c-driver_PACKAGE_FOLDER_RELEASE}/bin")
set(mongo-c-driver_mongo_bson_shared_LIBRARY_TYPE_RELEASE SHARED)
set(mongo-c-driver_mongo_bson_shared_IS_HOST_WINDOWS_RELEASE 0)
set(mongo-c-driver_mongo_bson_shared_RES_DIRS_RELEASE )
set(mongo-c-driver_mongo_bson_shared_DEFINITIONS_RELEASE )
set(mongo-c-driver_mongo_bson_shared_OBJECTS_RELEASE )
set(mongo-c-driver_mongo_bson_shared_COMPILE_DEFINITIONS_RELEASE )
set(mongo-c-driver_mongo_bson_shared_COMPILE_OPTIONS_C_RELEASE "")
set(mongo-c-driver_mongo_bson_shared_COMPILE_OPTIONS_CXX_RELEASE "")
set(mongo-c-driver_mongo_bson_shared_LIBS_RELEASE bson-1.0)
set(mongo-c-driver_mongo_bson_shared_SYSTEM_LIBS_RELEASE m pthread rt)
set(mongo-c-driver_mongo_bson_shared_FRAMEWORK_DIRS_RELEASE )
set(mongo-c-driver_mongo_bson_shared_FRAMEWORKS_RELEASE )
set(mongo-c-driver_mongo_bson_shared_DEPENDENCIES_RELEASE )
set(mongo-c-driver_mongo_bson_shared_SHARED_LINK_FLAGS_RELEASE )
set(mongo-c-driver_mongo_bson_shared_EXE_LINK_FLAGS_RELEASE )
set(mongo-c-driver_mongo_bson_shared_NO_SONAME_MODE_RELEASE FALSE)

# COMPOUND VARIABLES
set(mongo-c-driver_mongo_bson_shared_LINKER_FLAGS_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mongo-c-driver_mongo_bson_shared_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mongo-c-driver_mongo_bson_shared_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mongo-c-driver_mongo_bson_shared_EXE_LINK_FLAGS_RELEASE}>
)
set(mongo-c-driver_mongo_bson_shared_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${mongo-c-driver_mongo_bson_shared_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${mongo-c-driver_mongo_bson_shared_COMPILE_OPTIONS_C_RELEASE}>")