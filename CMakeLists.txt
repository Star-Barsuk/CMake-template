cmake_minimum_required(VERSION 3.28)

project(
    DefaultProject
    VERSION 0.1.0
    DESCRIPTION "C++23 CMake template"
    LANGUAGES CXX
)

include(cmake/ProjectVariables.cmake)
include(cmake/Options.cmake)
include(cmake/CompilerSupport.cmake)
include(cmake/TargetDefaults.cmake)

add_subdirectory(src)

include(CTest)

if(BUILD_TESTING)
    add_subdirectory(tests)
endif()

include(cmake/InstallRules.cmake)
