# Derived identifiers — update project() in the root CMakeLists.txt when forking.

string(TOLOWER "${PROJECT_NAME}" PROJECT_SLUG)

set(
    PROJECT_INCLUDE_DIR
    "${CMAKE_SOURCE_DIR}/include"
    CACHE INTERNAL
    "Include root for <${PROJECT_SLUG}/...> headers"
)
