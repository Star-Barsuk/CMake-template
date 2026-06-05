function(add_unit_test test_name)
    add_executable(${test_name} ${test_name}.cpp)
    project_link_settings(${test_name})
    project_set_output_directories(${test_name})
    target_link_libraries(
        ${test_name}
        PRIVATE
        ${PROJECT_NAME}::lib
    )
    add_test(NAME ${test_name} COMMAND ${test_name})
endfunction()

add_unit_test(test_parser)
add_unit_test(test_cstring)
