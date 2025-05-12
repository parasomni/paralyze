cmake_minimum_required(VERSION 3.15)

include(${CMAKE_BINARY_DIR}/conan_toolchain.cmake)
project(ControlServer LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Set the compiler
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_C_COMPILER clang)

# Source files
set(SOURCES
    Sources/BaseServer.cpp
    Sources/Essentials.cpp
    Sources/DBController.cpp
    Sources/ConfigModule.cpp
    Sources/ControlServer.cpp
    Sources/MainServer.cpp
)

# Add the executable
add_executable(ControlServer ${SOURCES})
target_include_directories(ControlServer PRIVATE ${CMAKE_SOURCE_DIR}/Headers)

# Compiler-specific options
if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    message(STATUS "Using Clang++")
    target_compile_options(ControlServer PRIVATE -Wall -Wextra -Wpedantic)
endif()

# Find MariaDB Connector/C++ library
find_library(MARIADBCPP_LIBRARY mariadbcpp HINTS /usr/local/lib/mariadb)

if (MARIADBCPP_LIBRARY)
    message(STATUS "Found mariadbcpp: ${MARIADBCPP_LIBRARY}")
    target_link_libraries(ControlServer PRIVATE ${MARIADBCPP_LIBRARY})
else()
    message(FATAL_ERROR "MariaDB C++ Connector library not found!")
endif()

# Add MariaDB include directory
target_include_directories(ControlServer PRIVATE /usr/local/include/mariadb)

# Dependencies
find_package(Boost REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(fmt REQUIRED)
find_package(mongocxx REQUIRED)

# Link dependencies
target_link_libraries(ControlServer PRIVATE
    Boost::boost
    openssl::openssl
    fmt::fmt-header-only
    mongo::mongocxx_shared
)
