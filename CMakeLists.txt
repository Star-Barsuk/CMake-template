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
# Sanitizers
# ============================================================

function(enable_sanitizers target_name)

    if(MSVC)
        return()
    endif()

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

    if(MSVC)

        target_compile_options(
            ${target_name}
            PRIVATE
            /W4
            /permissive-
        )

        if(WARNINGS_AS_ERRORS)

            target_compile_options(
                ${target_name}
                PRIVATE
                /WX
            )

        endif()

    else()

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

    endif()

    target_compile_definitions(
        ${target_name}
        PRIVATE
        $<$<CONFIG:Debug>:DEBUG_MODE>
    )

    if(ENABLE_THREADS)

        find_package(Threads REQUIRED)

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

    if(ENABLE_IPO)

        include(CheckIPOSupported)

        check_ipo_supported(
            RESULT ipo_supported
        )

        if(ipo_supported)

            set_property(
                TARGET ${target_name}
                PROPERTY
                INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE
            )

        endif()

    endif()

endfunction()

# ============================================================
# Root executables
# ============================================================

file(
    GLOB
    ROOT_SOURCES
    CONFIGURE_DEPENDS
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
)

foreach(source_file IN LISTS ROOT_SOURCES)

    get_filename_component(
        target_name
        ${source_file}
        NAME_WE
    )

    add_executable(
        ${target_name}
        ${source_file}
    )

    configure_target(${target_name})

endforeach()

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

        add_executable(
            ${child}
            ${cpp_files}
        )

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
