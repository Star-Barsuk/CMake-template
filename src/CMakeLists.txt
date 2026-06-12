add_subdirectory(lib)

add_executable(${PROJECT_SLUG} main.cpp)

target_link_libraries(
    ${PROJECT_SLUG}
    PRIVATE
    ${PROJECT_NAME}::lib
)

apply_target_defaults(${PROJECT_SLUG})
set_output_directories(${PROJECT_SLUG})

add_executable(${PROJECT_NAME}::cli ALIAS ${PROJECT_SLUG})
