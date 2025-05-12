# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/mongocxx-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${mongo-cxx-driver_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${mongocxx_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET mongo::mongocxx_shared)
    add_library(mongo::mongocxx_shared INTERFACE IMPORTED)
    message(${mongocxx_MESSAGE_MODE} "Conan: Target declared 'mongo::mongocxx_shared'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/mongocxx-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()