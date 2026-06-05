set(
    DEFAULTPROJECT_LIB_SOURCES
    app/application.cpp
    cli/parser.cpp
    cli/usage.cpp
    io/stdout_writer.cpp
)

add_library(defaultproject_lib STATIC ${DEFAULTPROJECT_LIB_SOURCES})

target_include_directories(
    defaultproject_lib
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_PUBLIC_INCLUDE_DIR}>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)

project_link_settings(defaultproject_lib)
project_set_output_directories(defaultproject_lib)

add_library(${PROJECT_NAME}::lib ALIAS defaultproject_lib)
