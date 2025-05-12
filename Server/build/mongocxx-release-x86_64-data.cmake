########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

list(APPEND mongo-cxx-driver_COMPONENT_NAMES mongo::bsoncxx_shared mongo::mongocxx_shared)
list(REMOVE_DUPLICATES mongo-cxx-driver_COMPONENT_NAMES)
if(DEFINED mongo-cxx-driver_FIND_DEPENDENCY_NAMES)
  list(APPEND mongo-cxx-driver_FIND_DEPENDENCY_NAMES mongoc-1.0 Boost)
  list(REMOVE_DUPLICATES mongo-cxx-driver_FIND_DEPENDENCY_NAMES)
else()
  set(mongo-cxx-driver_FIND_DEPENDENCY_NAMES mongoc-1.0 Boost)
endif()
set(mongoc-1.0_FIND_MODE "NO_MODULE")
set(Boost_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(mongo-cxx-driver_PACKAGE_FOLDER_RELEASE "/home/xpr/.conan2/p/b/mongo5313063350671/p")
set(mongo-cxx-driver_BUILD_MODULES_PATHS_RELEASE )


set(mongo-cxx-driver_INCLUDE_DIRS_RELEASE "${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/include"
			"${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/include/mongocxx/v_noabi"
			"${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/include/bsoncxx/v_noabi")
set(mongo-cxx-driver_RES_DIRS_RELEASE )
set(mongo-cxx-driver_DEFINITIONS_RELEASE )
set(mongo-cxx-driver_SHARED_LINK_FLAGS_RELEASE )
set(mongo-cxx-driver_EXE_LINK_FLAGS_RELEASE )
set(mongo-cxx-driver_OBJECTS_RELEASE )
set(mongo-cxx-driver_COMPILE_DEFINITIONS_RELEASE )
set(mongo-cxx-driver_COMPILE_OPTIONS_C_RELEASE )
set(mongo-cxx-driver_COMPILE_OPTIONS_CXX_RELEASE )
set(mongo-cxx-driver_LIB_DIRS_RELEASE "${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/lib")
set(mongo-cxx-driver_BIN_DIRS_RELEASE "${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/bin")
set(mongo-cxx-driver_LIBRARY_TYPE_RELEASE SHARED)
set(mongo-cxx-driver_IS_HOST_WINDOWS_RELEASE 0)
set(mongo-cxx-driver_LIBS_RELEASE mongocxx bsoncxx)
set(mongo-cxx-driver_SYSTEM_LIBS_RELEASE )
set(mongo-cxx-driver_FRAMEWORK_DIRS_RELEASE )
set(mongo-cxx-driver_FRAMEWORKS_RELEASE )
set(mongo-cxx-driver_BUILD_DIRS_RELEASE )
set(mongo-cxx-driver_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(mongo-cxx-driver_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${mongo-cxx-driver_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${mongo-cxx-driver_COMPILE_OPTIONS_C_RELEASE}>")
set(mongo-cxx-driver_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mongo-cxx-driver_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mongo-cxx-driver_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mongo-cxx-driver_EXE_LINK_FLAGS_RELEASE}>")


set(mongo-cxx-driver_COMPONENTS_RELEASE mongo::bsoncxx_shared mongo::mongocxx_shared)
########### COMPONENT mongo::mongocxx_shared VARIABLES ############################################

set(mongo-cxx-driver_mongo_mongocxx_shared_INCLUDE_DIRS_RELEASE "${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/include"
			"${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/include/mongocxx/v_noabi")
set(mongo-cxx-driver_mongo_mongocxx_shared_LIB_DIRS_RELEASE "${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/lib")
set(mongo-cxx-driver_mongo_mongocxx_shared_BIN_DIRS_RELEASE "${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/bin")
set(mongo-cxx-driver_mongo_mongocxx_shared_LIBRARY_TYPE_RELEASE SHARED)
set(mongo-cxx-driver_mongo_mongocxx_shared_IS_HOST_WINDOWS_RELEASE 0)
set(mongo-cxx-driver_mongo_mongocxx_shared_RES_DIRS_RELEASE )
set(mongo-cxx-driver_mongo_mongocxx_shared_DEFINITIONS_RELEASE )
set(mongo-cxx-driver_mongo_mongocxx_shared_OBJECTS_RELEASE )
set(mongo-cxx-driver_mongo_mongocxx_shared_COMPILE_DEFINITIONS_RELEASE )
set(mongo-cxx-driver_mongo_mongocxx_shared_COMPILE_OPTIONS_C_RELEASE "")
set(mongo-cxx-driver_mongo_mongocxx_shared_COMPILE_OPTIONS_CXX_RELEASE "")
set(mongo-cxx-driver_mongo_mongocxx_shared_LIBS_RELEASE mongocxx)
set(mongo-cxx-driver_mongo_mongocxx_shared_SYSTEM_LIBS_RELEASE )
set(mongo-cxx-driver_mongo_mongocxx_shared_FRAMEWORK_DIRS_RELEASE )
set(mongo-cxx-driver_mongo_mongocxx_shared_FRAMEWORKS_RELEASE )
set(mongo-cxx-driver_mongo_mongocxx_shared_DEPENDENCIES_RELEASE mongo::mongoc_static mongo::bsoncxx_shared)
set(mongo-cxx-driver_mongo_mongocxx_shared_SHARED_LINK_FLAGS_RELEASE )
set(mongo-cxx-driver_mongo_mongocxx_shared_EXE_LINK_FLAGS_RELEASE )
set(mongo-cxx-driver_mongo_mongocxx_shared_NO_SONAME_MODE_RELEASE FALSE)

# COMPOUND VARIABLES
set(mongo-cxx-driver_mongo_mongocxx_shared_LINKER_FLAGS_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mongo-cxx-driver_mongo_mongocxx_shared_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mongo-cxx-driver_mongo_mongocxx_shared_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mongo-cxx-driver_mongo_mongocxx_shared_EXE_LINK_FLAGS_RELEASE}>
)
set(mongo-cxx-driver_mongo_mongocxx_shared_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${mongo-cxx-driver_mongo_mongocxx_shared_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${mongo-cxx-driver_mongo_mongocxx_shared_COMPILE_OPTIONS_C_RELEASE}>")
########### COMPONENT mongo::bsoncxx_shared VARIABLES ############################################

set(mongo-cxx-driver_mongo_bsoncxx_shared_INCLUDE_DIRS_RELEASE "${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/include"
			"${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/include/bsoncxx/v_noabi")
set(mongo-cxx-driver_mongo_bsoncxx_shared_LIB_DIRS_RELEASE "${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/lib")
set(mongo-cxx-driver_mongo_bsoncxx_shared_BIN_DIRS_RELEASE "${mongo-cxx-driver_PACKAGE_FOLDER_RELEASE}/bin")
set(mongo-cxx-driver_mongo_bsoncxx_shared_LIBRARY_TYPE_RELEASE SHARED)
set(mongo-cxx-driver_mongo_bsoncxx_shared_IS_HOST_WINDOWS_RELEASE 0)
set(mongo-cxx-driver_mongo_bsoncxx_shared_RES_DIRS_RELEASE )
set(mongo-cxx-driver_mongo_bsoncxx_shared_DEFINITIONS_RELEASE )
set(mongo-cxx-driver_mongo_bsoncxx_shared_OBJECTS_RELEASE )
set(mongo-cxx-driver_mongo_bsoncxx_shared_COMPILE_DEFINITIONS_RELEASE )
set(mongo-cxx-driver_mongo_bsoncxx_shared_COMPILE_OPTIONS_C_RELEASE "")
set(mongo-cxx-driver_mongo_bsoncxx_shared_COMPILE_OPTIONS_CXX_RELEASE "")
set(mongo-cxx-driver_mongo_bsoncxx_shared_LIBS_RELEASE bsoncxx)
set(mongo-cxx-driver_mongo_bsoncxx_shared_SYSTEM_LIBS_RELEASE )
set(mongo-cxx-driver_mongo_bsoncxx_shared_FRAMEWORK_DIRS_RELEASE )
set(mongo-cxx-driver_mongo_bsoncxx_shared_FRAMEWORKS_RELEASE )
set(mongo-cxx-driver_mongo_bsoncxx_shared_DEPENDENCIES_RELEASE mongo::bson_static Boost::headers)
set(mongo-cxx-driver_mongo_bsoncxx_shared_SHARED_LINK_FLAGS_RELEASE )
set(mongo-cxx-driver_mongo_bsoncxx_shared_EXE_LINK_FLAGS_RELEASE )
set(mongo-cxx-driver_mongo_bsoncxx_shared_NO_SONAME_MODE_RELEASE FALSE)

# COMPOUND VARIABLES
set(mongo-cxx-driver_mongo_bsoncxx_shared_LINKER_FLAGS_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${mongo-cxx-driver_mongo_bsoncxx_shared_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${mongo-cxx-driver_mongo_bsoncxx_shared_SHARED_LINK_FLAGS_RELEASE}>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${mongo-cxx-driver_mongo_bsoncxx_shared_EXE_LINK_FLAGS_RELEASE}>
)
set(mongo-cxx-driver_mongo_bsoncxx_shared_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${mongo-cxx-driver_mongo_bsoncxx_shared_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${mongo-cxx-driver_mongo_bsoncxx_shared_COMPILE_OPTIONS_C_RELEASE}>")