# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/mongoc-1.0-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${mongo-c-driver_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${mongoc-1.0_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET mongo::mongoc_shared)
    add_library(mongo::mongoc_shared INTERFACE IMPORTED)
    message(${mongoc-1.0_MESSAGE_MODE} "Conan: Target declared 'mongo::mongoc_shared'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/mongoc-1.0-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()