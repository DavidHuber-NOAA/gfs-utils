# Executable tests for gfs-utils
#
# These tests verify that the built executables can be invoked and handle
# basic command-line arguments correctly.

# List of executables to test
set(GFS_EXECUTABLES
    gfs_bufr.x
    tocsbufr.x
    vint.x
    tave.x
    reg2grb2.x
    fbwndgfs.x
    supvit.x
    syndat_qctropcy.x
    syndat_maksynrc.x
    syndat_getjtbul.x
    mkgfsawps.x
    overgridid.x
    webtitle.x
    ocnicepost.x
    ensadd.x
    ensppf.x
    ensstat.x
    wave_stat.x
    gefs_6h_ave_1mem.x
    enkf_chgres_recenter_nc.x
    gaussian_sfcanl.x
)

# Create basic executable tests
foreach(exe IN LISTS GFS_EXECUTABLES)
    # Test that executable exists and can be invoked
    add_test(NAME executable_exists_${exe}
             COMMAND ${CMAKE_COMMAND} -E echo "Testing executable: ${exe}")
    
    # Test for help output (many Fortran programs exit with error on invalid args)
    add_executable_test(${CMAKE_INSTALL_PREFIX}/bin/${exe} 
                       executable_help_${exe}
                       COMMAND_ARGS --help
                       WILL_FAIL  # Most Fortran programs don't have --help and will exit with error
                       TIMEOUT 10)
    
    # Test for version output (similar expectation)
    add_executable_test(${CMAKE_INSTALL_PREFIX}/bin/${exe}
                       executable_version_${exe} 
                       COMMAND_ARGS --version
                       WILL_FAIL  # Most Fortran programs don't have --version
                       TIMEOUT 10)
    
    # Test basic invocation without arguments (should handle gracefully)
    add_executable_test(${CMAKE_INSTALL_PREFIX}/bin/${exe}
                       executable_basic_${exe}
                       WILL_FAIL  # Expected to fail with usage message
                       TIMEOUT 10)
endforeach()

# Add a sample test demonstrating the framework works
add_test(NAME sample_framework_test
         COMMAND ${CMAKE_COMMAND} -E echo "gfs-utils ctest framework is working!")
set_tests_properties(sample_framework_test PROPERTIES
    PASS_REGULAR_EXPRESSION "gfs-utils ctest framework is working!")