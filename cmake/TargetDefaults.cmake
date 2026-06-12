# INTERFACE targets and helpers applied to every project target.

add_library(${PROJECT_SLUG}_options INTERFACE)
add_library(${PROJECT_SLUG}_warnings INTERFACE)
add_library(${PROJECT_SLUG}_sanitizers INTERFACE)

add_library(${PROJECT_NAME}::options ALIAS ${PROJECT_SLUG}_options)
add_library(${PROJECT_NAME}::warnings ALIAS ${PROJECT_SLUG}_warnings)
add_library(${PROJECT_NAME}::sanitizers ALIAS ${PROJECT_SLUG}_sanitizers)

target_compile_features(${PROJECT_SLUG}_options INTERFACE cxx_std_23)

target_compile_options(
    ${PROJECT_SLUG}_options
    INTERFACE
    $<$<CONFIG:Debug>:-O0>
    $<$<CONFIG:Debug>:-g>
    $<$<CONFIG:Release>:-O3>
)

target_compile_definitions(
    ${PROJECT_SLUG}_options
    INTERFACE
    $<$<CONFIG:Debug>:DEBUG_MODE>
)

target_compile_options(
    ${PROJECT_SLUG}_warnings
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
    ${PROJECT_SLUG}_sanitizers
    INTERFACE
    -fsanitize=address
    -fsanitize=undefined
)

target_link_options(
    ${PROJECT_SLUG}_sanitizers
    INTERFACE
    -fsanitize=address
    -fsanitize=undefined
)

function(apply_target_defaults target)
    target_link_libraries(
        ${target}
        PRIVATE
        ${PROJECT_SLUG}_options
        ${PROJECT_SLUG}_warnings
    )

    if(ENABLE_THREADS)
        target_link_libraries(${target} PRIVATE Threads::Threads)
    endif()

    if(ENABLE_SANITIZERS AND CMAKE_BUILD_TYPE STREQUAL "Debug")
        target_link_libraries(${target} PRIVATE ${PROJECT_SLUG}_sanitizers)
    endif()

    if(ENABLE_IPO AND PROJECT_IPO_SUPPORTED)
        set_property(
            TARGET ${target}
            PROPERTY INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE
        )
    endif()
endfunction()

function(set_output_directories target)
    set_target_properties(
        ${target}
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}"
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}/lib"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}/lib"
    )
endfunction()
