if(NOT CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    message(
        FATAL_ERROR
        "Unsupported compiler '${CMAKE_CXX_COMPILER_ID}'. GCC and Clang only."
    )
endif()

if(ENABLE_THREADS)
    find_package(Threads REQUIRED)
endif()

set(PROJECT_IPO_SUPPORTED FALSE)

if(ENABLE_IPO)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT PROJECT_IPO_SUPPORTED)
endif()
