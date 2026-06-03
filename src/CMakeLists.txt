set(
    DEFAULTPROJECT_CORE_SOURCES
    calculator/calculator.cpp
)

add_library(truecontext_core STATIC ${DEFAULTPROJECT_CORE_SOURCES})
configure_target(truecontext_core)

target_include_directories(
    truecontext_core
    PUBLIC
    "${PROJECT_PUBLIC_INCLUDE_DIR}"
)

add_executable(true_context main.cpp)
configure_target(true_context)

target_link_libraries(
    true_context
    PRIVATE
    truecontext_core
)
