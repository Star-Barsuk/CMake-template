cmake_minimum_required(VERSION 3.28)

project(
    DefaultProject
    VERSION 1.0.0
    DESCRIPTION "Universal C++23 Template"
    LANGUAGES CXX
)

# ============================================================
# Options
# ============================================================

option(
    SINGLE_APP
    "Build only src/main.cpp as the executable (no src/*.cpp glob, no directory executables)"
    OFF
)

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

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(NOT CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    message(
        FATAL_ERROR
        "Unsupported compiler '${CMAKE_CXX_COMPILER_ID}'. This template supports GCC and Clang only."
    )
endif()

# ============================================================
# Output directories
# ============================================================

set(
    CMAKE_RUNTIME_OUTPUT_DIRECTORY
    ${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}
)

set(
    CMAKE_ARCHIVE_OUTPUT_DIRECTORY
    ${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}/lib
)

set(
    CMAKE_LIBRARY_OUTPUT_DIRECTORY
    ${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}/lib
)

# ============================================================
# Project-wide dependencies and capabilities
# ============================================================

if(ENABLE_THREADS)
    find_package(Threads REQUIRED)
endif()

set(PROJECT_IPO_SUPPORTED FALSE)

if(ENABLE_IPO)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT PROJECT_IPO_SUPPORTED)
endif()

# ============================================================
# Sanitizers
# ============================================================

function(enable_sanitizers target_name)
    target_compile_options(
        ${target_name}
        PRIVATE
        -fsanitize=address
        -fsanitize=undefined
    )

    target_link_options(
        ${target_name}
        PRIVATE
        -fsanitize=address
        -fsanitize=undefined
    )
endfunction()

# ============================================================
# Common target setup
# ============================================================

function(configure_target target_name)

    target_compile_features(
        ${target_name}
        PRIVATE
        cxx_std_23
    )

    target_compile_options(
        ${target_name}
        PRIVATE

        -Wall
        -Wextra
        -Wpedantic

        -Wshadow
        -Wconversion
        -Wsign-conversion

        $<$<CONFIG:Debug>:-O0>
        $<$<CONFIG:Debug>:-g>

        $<$<CONFIG:Release>:-O3>
    )

    if(WARNINGS_AS_ERRORS)
        target_compile_options(
            ${target_name}
            PRIVATE
            -Werror
        )
    endif()

    target_compile_definitions(
        ${target_name}
        PRIVATE
        $<$<CONFIG:Debug>:DEBUG_MODE>
    )

    if(ENABLE_THREADS)
        target_link_libraries(
            ${target_name}
            PRIVATE
            Threads::Threads
        )
    endif()

    if(
        ENABLE_SANITIZERS
        AND CMAKE_BUILD_TYPE STREQUAL "Debug"
    )
        enable_sanitizers(${target_name})
    endif()

    if(ENABLE_IPO AND PROJECT_IPO_SUPPORTED)
        set_property(
            TARGET ${target_name}
            PROPERTY INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE
        )
    endif()

endfunction()

# ============================================================
# Root executables
# ============================================================

if(SINGLE_APP)

    set(_single_app_source "${CMAKE_SOURCE_DIR}/src/main.cpp")

    if(NOT EXISTS "${_single_app_source}")
        message(
            FATAL_ERROR
            "SINGLE_APP is ON but '${_single_app_source}' was not found."
        )
    endif()

    add_executable(${PROJECT_NAME} "${_single_app_source}")
    configure_target(${PROJECT_NAME})

else()

    file(
        GLOB
        ROOT_SOURCES
        CONFIGURE_DEPENDS
        "${CMAKE_SOURCE_DIR}/src/*.cpp"
    )

    list(FILTER ROOT_SOURCES EXCLUDE REGEX "/main\\.cpp$")

    foreach(source_file IN LISTS ROOT_SOURCES)

        get_filename_component(
            target_name
            ${source_file}
            NAME_WE
        )

        add_executable(${target_name} ${source_file})
        configure_target(${target_name})

    endforeach()

endif()

# ============================================================
# Directories
# ============================================================

file(
    GLOB
    CHILDREN
    RELATIVE
    "${CMAKE_SOURCE_DIR}/src"
    "${CMAKE_SOURCE_DIR}/src/*"
)

foreach(child ${CHILDREN})

    set(dir_path "${CMAKE_SOURCE_DIR}/src/${child}")

    if(NOT IS_DIRECTORY "${dir_path}")
        continue()
    endif()

    file(
        GLOB_RECURSE
        cpp_files
        CONFIGURE_DEPENDS
        "${dir_path}/*.cpp"
    )

    if(NOT cpp_files)
        continue()
    endif()

    set(main_file "${dir_path}/main.cpp")

    if(EXISTS "${main_file}")

        if(SINGLE_APP)
            continue()
        endif()

        add_executable(${child} ${cpp_files})

        target_include_directories(
            ${child}
            PRIVATE
            ${dir_path}
        )

        configure_target(${child})

    else()

        add_library(
            ${child}
            STATIC
            ${cpp_files}
        )

        target_include_directories(
            ${child}
            PUBLIC
            ${dir_path}
        )

        configure_target(${child})

    endif()

endforeach()
