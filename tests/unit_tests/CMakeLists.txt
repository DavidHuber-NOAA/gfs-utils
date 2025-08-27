# Unit tests for individual Fortran functions and subroutines
#
# This directory contains tests that isolate and test specific functions
# and subroutines from the gfs-utils Fortran modules.

# Create a sample unit test to demonstrate the framework
add_fortran_unit_test(sample_funcphys_test sample_funcphys_test.f90)

# Function to easily add tests for specific modules
function(add_module_unit_tests module_name)
    set(test_sources)
    
    # Look for test files matching the pattern test_${module_name}_*.f90
    file(GLOB test_files "${CMAKE_CURRENT_SOURCE_DIR}/test_${module_name}_*.f90")
    
    foreach(test_file IN LISTS test_files)
        get_filename_component(test_name ${test_file} NAME_WE)
        add_fortran_unit_test(${test_name} ${test_file})
    endforeach()
endfunction()

# Add tests for specific modules that have isolated functions
# These would be expanded as the testing framework is used
add_module_unit_tests(funcphys)
add_module_unit_tests(meteorg)
add_module_unit_tests(machine)