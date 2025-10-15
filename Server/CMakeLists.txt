cmake_minimum_required(VERSION 3.15)

include(${CMAKE_BINARY_DIR}/conan_toolchain.cmake)
project(CCServer LANGUAGES CXX)

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
    Sources/CCServer.cpp
    Sources/MainServer.cpp
)

# Add the executable
add_executable(CCServer ${SOURCES})
target_include_directories(CCServer PRIVATE /path/to/paralyze/Server/Headers)

# Compiler-specific options
if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    message(STATUS "Using Clang++")
    target_compile_options(CCServer PRIVATE -Wall -Wextra -Wpedantic)
endif()

# Find and link Connector/C++
find_library(MARIADBCPP_LIBRARY mariadbcpp HINTS /usr/local/lib/mariadb)
find_library(MARIADB_C_LIBRARY mariadb HINTS /usr/lib /usr/local/lib /usr/lib/x86_64-linux-gnu)

if (MARIADBCPP_LIBRARY AND MARIADB_C_LIBRARY)
    message(STATUS "Found mariadbcpp: ${MARIADBCPP_LIBRARY}")
    message(STATUS "Found mariadb C: ${MARIADB_C_LIBRARY}")
    target_link_libraries(CCServer PRIVATE ${MARIADBCPP_LIBRARY} ${MARIADB_C_LIBRARY})
else()
    message(FATAL_ERROR "MariaDB libraries not found!")
endif()

# Include headers
target_include_directories(CCServer PRIVATE /usr/local/include/mariadb)

# Dependencies
find_package(Boost REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(fmt REQUIRED)
find_package(mongocxx REQUIRED)
find_package(nlohmann_json REQUIRED)
find_package(jwt-cpp REQUIRED)

# Link dependencies
target_link_libraries(CCServer PRIVATE
    Boost::boost
    OpenSSL::SSL
    OpenSSL::Crypto
    fmt::fmt-header-only
    mongo::mongocxx_shared
    nlohmann_json::nlohmann_json
    jwt-cpp::jwt-cpp
)