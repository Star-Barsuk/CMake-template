add_library(
    math
    STATIC
    vector.cpp
)

target_include_directories(
    math
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

configure_target(math)

add_library(
    ${PROJECT_NAME}::math
    ALIAS
    math
)
