add_library(util INTERFACE)

target_include_directories(
    util
    INTERFACE
    "$<BUILD_INTERFACE:${PROJECT_PUBLIC_INCLUDE_DIR}>"
    "$<INSTALL_INTERFACE:include>"
)

add_library(
    ${PROJECT_NAME}::util
    ALIAS
    util
)
