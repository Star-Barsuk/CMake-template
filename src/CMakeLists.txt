add_subdirectory(lib)

add_executable(defaultproject cli/main.cpp)

target_link_libraries(
    defaultproject
    PRIVATE
    ${PROJECT_NAME}::lib
)

project_link_settings(defaultproject)
project_set_output_directories(defaultproject)
