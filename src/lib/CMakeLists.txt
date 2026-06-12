add_library(
    ${PROJECT_SLUG}_lib
    STATIC
    app/application.cpp
    cli/parser.cpp
    cli/usage.cpp
    io/stdout_writer.cpp
)

target_include_directories(
    ${PROJECT_SLUG}_lib
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_INCLUDE_DIR}>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)

apply_target_defaults(${PROJECT_SLUG}_lib)
set_output_directories(${PROJECT_SLUG}_lib)

add_library(${PROJECT_NAME}::lib ALIAS ${PROJECT_SLUG}_lib)
