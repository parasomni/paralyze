# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/mariadb-connector-c-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${mariadb-connector-c_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${mariadb-connector-c_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET mariadb-connector-c::mariadb-connector-c)
    add_library(mariadb-connector-c::mariadb-connector-c INTERFACE IMPORTED)
    message(${mariadb-connector-c_MESSAGE_MODE} "Conan: Target declared 'mariadb-connector-c::mariadb-connector-c'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/mariadb-connector-c-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()