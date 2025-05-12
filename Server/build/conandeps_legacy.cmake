message(STATUS "Conan: Using CMakeDeps conandeps_legacy.cmake aggregator via include()")
message(STATUS "Conan: It is recommended to use explicit find_package() per dependency instead")

find_package(fmt)
find_package(mongocxx)
find_package(Boost)
find_package(mariadb-connector-c)
find_package(OpenSSL)
find_package(zstd)

set(CONANDEPS_LEGACY  fmt::fmt-header-only  mongo::mongocxx_shared  boost::boost  mariadb-connector-c::mariadb-connector-c  openssl::openssl  zstd::libzstd_static )