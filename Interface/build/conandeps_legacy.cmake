message(STATUS "Conan: Using CMakeDeps conandeps_legacy.cmake aggregator via include()")
message(STATUS "Conan: It is recommended to use explicit find_package() per dependency instead")

find_package(fmt)
find_package(mongocxx)
find_package(mongoc-1.0)

set(CONANDEPS_LEGACY  fmt::fmt-header-only  mongo::mongocxx_shared  mongo::mongoc_shared )