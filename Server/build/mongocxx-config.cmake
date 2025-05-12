########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(mongocxx_FIND_QUIETLY)
    set(mongocxx_MESSAGE_MODE VERBOSE)
else()
    set(mongocxx_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/mongocxxTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${mongo-cxx-driver_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(mongocxx_VERSION_STRING "3.11.0")
set(mongocxx_INCLUDE_DIRS ${mongo-cxx-driver_INCLUDE_DIRS_RELEASE} )
set(mongocxx_INCLUDE_DIR ${mongo-cxx-driver_INCLUDE_DIRS_RELEASE} )
set(mongocxx_LIBRARIES ${mongo-cxx-driver_LIBRARIES_RELEASE} )
set(mongocxx_DEFINITIONS ${mongo-cxx-driver_DEFINITIONS_RELEASE} )


# Only the last installed configuration BUILD_MODULES are included to avoid the collision
foreach(_BUILD_MODULE ${mongo-cxx-driver_BUILD_MODULES_PATHS_RELEASE} )
    message(${mongocxx_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


