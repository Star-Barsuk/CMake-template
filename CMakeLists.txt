cmake_minimum_required(VERSION 3.28)

project(
    DefaultProjectName
    VERSION 0.1.0
    DESCRIPTION "Description of the project"
    LANGUAGES CXX
)

set(
    PROJECT_PUBLIC_INCLUDE_DIR
    "${CMAKE_SOURCE_DIR}/include"
    CACHE INTERNAL
    "Include root for <defaultproject/...> headers"
)

# ============================================================
# Options
# ============================================================

option(
    ENABLE_THREADS
    "Enable Threads::Threads linkage"
    OFF
)

option(
    ENABLE_IPO
    "Enable IPO/LTO in Release"
    ON
)

option(
    ENABLE_SANITIZERS
    "Enable Address/Undefined sanitizers"
    OFF
)

option(
    WARNINGS_AS_ERRORS
    "Treat warnings as errors"
    OFF
)

# ============================================================
# Global C++ settings
# ============================================================

if(NOT CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    message(
        FATAL_ERROR
        "Unsupported compiler '${CMAKE_CXX_COMPILER_ID}'. Supports GCC and Clang only."
    )
endif()

# ============================================================
# Project-wide dependencies and capabilities
# ============================================================

include(cmake/ProjectSettings.cmake)

if(ENABLE_THREADS)
    find_package(Threads REQUIRED)
endif()

set(PROJECT_IPO_SUPPORTED FALSE)

if(ENABLE_IPO)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT PROJECT_IPO_SUPPORTED)
endif()

# ============================================================
# Targets
# ============================================================

add_subdirectory(src)

include(CTest)

if(BUILD_TESTING)
    add_subdirectory(tests)
endif()

include(cmake/InstallRules.cmake)
