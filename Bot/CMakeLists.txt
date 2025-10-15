cmake_minimum_required(VERSION 3.15)

include(${CMAKE_BINARY_DIR}/conan_toolchain.cmake)
project(ParalyzeBot LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Set the compiler
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_C_COMPILER clang)

#file (GLOB_RECURSE SOURCES "*.cpp")
set (SOURCES
    Sources/ControlModule.cpp
    Sources/NetworkEssentials.cpp
    Sources/NetworkModule.cpp
    Sources/BotEssentials.cpp
    Sources/ParalyzeBot.cpp
    Sources/NukeModule.cpp
    Sources/LoaderModule.cpp
    Sources/DoSModule.cpp
    Sources/ProxyModule.cpp
)

# Add the executable
add_executable(ParalyzeBot ${SOURCES})
target_include_directories(ParalyzeBot PRIVATE ${CMAKE_SOURCE_DIR}/Headers)

if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    message(STATUS "Using Clang++")
    target_compile_options(ParalyzeBot PRIVATE 
      -Wall -Wextra -Wpedantic 
      -fsanitize=address,undefined
      -fno-omit-frame-pointer
      -g
    )
    target_link_options(ParalyzeBot PRIVATE
      -fsanitize=address,undefined
    )
endif()

find_package(Boost REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(fmt REQUIRED)

# Link dependencies to the target
target_link_libraries(ParalyzeBot
    boost::boost
    openssl::openssl
    fmt::fmt-header-only
)
