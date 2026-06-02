add_library(
    calculator
    STATIC
    calculator.cpp
)

target_include_directories(
    calculator
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_PUBLIC_INCLUDE_DIR}>"
    "$<INSTALL_INTERFACE:include>"
)

target_link_libraries(
    calculator
    PUBLIC
    ${PROJECT_NAME}::math
    PRIVATE
    ${PROJECT_NAME}::util
)

configure_target(calculator)

add_library(
    ${PROJECT_NAME}::calculator
    ALIAS
    calculator
)
