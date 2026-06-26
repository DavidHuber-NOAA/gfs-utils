# Test configuration for gfs-utils
#
# This file provides a testing framework for the gfs-utils project using ctest.
# It includes both executable tests and unit tests for individual Fortran functions.

cmake_minimum_required(VERSION 3.19)

# Helper function to create executable tests
function(add_executable_test exe_name test_name)
    set(options WILL_FAIL)
    set(oneValueArgs WORKING_DIRECTORY TIMEOUT)
    set(multiValueArgs COMMAND_ARGS PROPERTIES)
    cmake_parse_arguments(ADD_EXE_TEST "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # Default working directory to CMAKE_CURRENT_BINARY_DIR
    if(NOT ADD_EXE_TEST_WORKING_DIRECTORY)
        set(ADD_EXE_TEST_WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
    endif()
    
    # Default timeout to 30 seconds
    if(NOT ADD_EXE_TEST_TIMEOUT)
        set(ADD_EXE_TEST_TIMEOUT 30)
    endif()
    
    # Create the test
    add_test(NAME ${test_name}
             COMMAND ${exe_name} ${ADD_EXE_TEST_COMMAND_ARGS}
             WORKING_DIRECTORY ${ADD_EXE_TEST_WORKING_DIRECTORY})
    
    # Set basic properties
    set_tests_properties(${test_name} PROPERTIES
        TIMEOUT ${ADD_EXE_TEST_TIMEOUT}
        ${ADD_EXE_TEST_PROPERTIES}
    )
    
    if(ADD_EXE_TEST_WILL_FAIL)
        set_tests_properties(${test_name} PROPERTIES WILL_FAIL TRUE)
    endif()
endfunction()

# Helper function to create unit tests for Fortran modules
function(add_fortran_unit_test test_name source_file)
    set(options)
    set(oneValueArgs TIMEOUT)
    set(multiValueArgs LINK_LIBRARIES PROPERTIES)
    cmake_parse_arguments(ADD_UNIT_TEST "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # Create executable for the unit test
    add_executable(${test_name} ${source_file})
    
    # Link against any required libraries
    if(ADD_UNIT_TEST_LINK_LIBRARIES)
        target_link_libraries(${test_name} PRIVATE ${ADD_UNIT_TEST_LINK_LIBRARIES})
    endif()
    
    # Default timeout to 30 seconds
    if(NOT ADD_UNIT_TEST_TIMEOUT)
        set(ADD_UNIT_TEST_TIMEOUT 30)
    endif()
    
    # Add the test
    add_test(NAME ${test_name} COMMAND ${test_name})
    set_tests_properties(${test_name} PROPERTIES
        TIMEOUT ${ADD_UNIT_TEST_TIMEOUT}
        ${ADD_UNIT_TEST_PROPERTIES}
    )
endfunction()

# Add subdirectories for different types of tests
add_subdirectory(executable_tests)
add_subdirectory(unit_tests)