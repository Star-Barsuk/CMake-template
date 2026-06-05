# INTERFACE targets for modern, composable CMake configuration.

add_library(project_options INTERFACE)
add_library(project_warnings INTERFACE)
add_library(project_sanitizers INTERFACE)

target_compile_features(project_options INTERFACE cxx_std_23)

target_compile_options(
    project_options
    INTERFACE
    $<$<CONFIG:Debug>:-O0>
    $<$<CONFIG:Debug>:-g>
    $<$<CONFIG:Release>:-O3>
)

target_compile_definitions(
    project_options
    INTERFACE
    $<$<CONFIG:Debug>:DEBUG_MODE>
)

target_compile_options(
    project_warnings
    INTERFACE
    -Wall
    -Wextra
    -Wpedantic
    -Wshadow
    -Wconversion
    -Wsign-conversion
    $<$<BOOL:${WARNINGS_AS_ERRORS}>:-Werror>
)

target_compile_options(
    project_sanitizers
    INTERFACE
    -fsanitize=address
    -fsanitize=undefined
)

target_link_options(
    project_sanitizers
    INTERFACE
    -fsanitize=address
    -fsanitize=undefined
)

function(project_link_settings target_name)
    target_link_libraries(
        ${target_name}
        PRIVATE
        project_options
        project_warnings
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
        target_link_libraries(
            ${target_name}
            PRIVATE
            project_sanitizers
        )
    endif()

    if(ENABLE_IPO AND PROJECT_IPO_SUPPORTED)
        set_property(
            TARGET ${target_name}
            PROPERTY INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE
        )
    endif()
endfunction()

function(project_set_output_directories target_name)
    set_target_properties(
        ${target_name}
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}"
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}/lib"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}/lib"
    )
endfunction()
