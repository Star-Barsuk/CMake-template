add_library(
    calculator
    STATIC
    calculator.cpp
)

target_include_directories(
    calculator
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(
    calculator
    PUBLIC
    ${PROJECT_NAME}::math
)

configure_target(calculator)

add_library(
    ${PROJECT_NAME}::calculator
    ALIAS
    calculator
)
