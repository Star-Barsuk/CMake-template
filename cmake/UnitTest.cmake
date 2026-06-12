function(add_unit_test name)
    set(target "${PROJECT_SLUG}_test_${name}")
    set(source "${CMAKE_CURRENT_SOURCE_DIR}/${name}_test.cpp")

    add_executable(${target} ${source})
    apply_target_defaults(${target})
    set_output_directories(${target})

    target_link_libraries(
        ${target}
        PRIVATE
        ${PROJECT_NAME}::lib
    )

    add_test(NAME ${target} COMMAND ${target})
endfunction()
