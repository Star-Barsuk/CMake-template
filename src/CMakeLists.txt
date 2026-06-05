set(
    DEFAULTPROJECT_CORE_SOURCES
    io/stdout_writer.cpp
    cli/parser.cpp
    cli/usage.cpp
    app/application.cpp
)

add_library(defaultproject_core STATIC ${DEFAULTPROJECT_CORE_SOURCES})
configure_target(defaultproject_core)

target_include_directories(
    defaultproject_core
    PUBLIC
    "${PROJECT_PUBLIC_INCLUDE_DIR}"
)

add_executable(defaultproject main.cpp)
configure_target(defaultproject)

target_link_libraries(
    defaultproject
    PRIVATE
    defaultproject_core
)
