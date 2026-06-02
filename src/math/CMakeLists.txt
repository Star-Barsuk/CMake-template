add_library(
    math
    STATIC
    vector.cpp
)

target_include_directories(
    math
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_PUBLIC_INCLUDE_DIR}>"
    "$<INSTALL_INTERFACE:include>"
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(
    math
    PRIVATE
    ${PROJECT_NAME}::util
)

configure_target(math)

add_library(
    ${PROJECT_NAME}::math
    ALIAS
    math
)
