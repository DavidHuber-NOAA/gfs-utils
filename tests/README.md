# GFS-Utils Testing Framework

This directory contains a comprehensive testing framework for the gfs-utils project using CMake's ctest functionality. The framework provides both executable-level tests and unit tests for individual Fortran functions and subroutines.

## Framework Structure

```
tests/
├── CMakeLists.txt              # Main test configuration and helper functions
├── executable_tests/           # Tests for complete executables
│   └── CMakeLists.txt
├── unit_tests/                 # Unit tests for individual functions
│   ├── CMakeLists.txt
│   ├── sample_funcphys_test.f90  # Sample unit test demonstrating framework
│   └── test_*.f90              # Additional unit test files
└── README.md                   # This file
```

## Running Tests

### Building with Tests

```bash
# Configure the project (from the root directory)
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release

# Build the project
make -j8

# Install executables (required for executable tests)
make install
```

### Running All Tests

```bash
# Run all tests
ctest

# Run tests with verbose output
ctest -V

# Run specific test patterns
ctest -R "executable_*"    # Run only executable tests
ctest -R "sample_*"        # Run only sample tests
```

### Running Individual Tests

```bash
# Run a specific test
ctest -R "sample_framework_test"

# Run tests matching a pattern
ctest -R "executable_help_*"
```

## Test Types

### 1. Executable Tests

Located in `executable_tests/`, these tests verify that built executables:
- Can be invoked without crashing
- Handle command-line arguments appropriately
- Exist in the expected installation location

**Example executable tests:**
- `executable_exists_gfs_bufr.x` - Verifies the executable exists
- `executable_basic_gfs_bufr.x` - Tests basic invocation
- `executable_help_gfs_bufr.x` - Tests help argument handling

### 2. Unit Tests

Located in `unit_tests/`, these tests isolate and test individual Fortran functions and subroutines.

**Key features:**
- Test individual functions in isolation
- Provide detailed assertion mechanisms
- Can test mathematical accuracy of physics calculations
- Support for testing error conditions

## Creating New Tests

### Adding Executable Tests

To add tests for a new executable, edit `executable_tests/CMakeLists.txt`:

```cmake
# Add your executable to the list
set(GFS_EXECUTABLES
    # ... existing executables ...
    your_new_executable.x
)
```

The framework will automatically create standard tests for your executable.

### Adding Unit Tests

1. Create a new Fortran test file in `unit_tests/` following the pattern `test_module_*.f90`
2. Use the provided helper functions from the main test CMakeLists.txt:

```cmake
# In unit_tests/CMakeLists.txt
add_fortran_unit_test(test_your_module test_your_module.f90)
```

### Sample Unit Test Structure

```fortran
program test_your_function
    implicit none
    
    ! Test setup
    integer, parameter :: krealfp = kind(1.0)
    real(krealfp), parameter :: tolerance = 1.0e-6_krealfp
    logical :: all_tests_passed = .true.
    
    ! Run tests
    call test_specific_function()
    
    ! Report results
    if (all_tests_passed) then
        stop 0  ! Success
    else
        stop 1  ! Failure
    endif
    
contains
    subroutine test_specific_function()
        ! Your test implementation
        real(krealfp) :: input, expected, result
        
        input = 1.0_krealfp
        expected = 2.0_krealfp
        result = your_function(input)
        
        call assert_equal(result, expected, 'Function test')
    end subroutine
    
    subroutine assert_equal(actual, expected, test_name)
        ! Assertion helper (see sample_funcphys_test.f90 for full implementation)
    end subroutine
end program
```

## Helper Functions

The framework provides several CMake helper functions:

### `add_executable_test(exe_name test_name [options])`

Creates a test for an executable with the following options:
- `COMMAND_ARGS` - Arguments to pass to the executable
- `WILL_FAIL` - Expect the test to fail (useful for testing error handling)
- `WORKING_DIRECTORY` - Directory to run the test in
- `TIMEOUT` - Test timeout in seconds
- `PROPERTIES` - Additional test properties

### `add_fortran_unit_test(test_name source_file [options])`

Creates a unit test from a Fortran source file with options:
- `LINK_LIBRARIES` - Libraries to link against
- `TIMEOUT` - Test timeout in seconds
- `PROPERTIES` - Additional test properties

## Integration with CI/CD

The testing framework is designed to integrate with GitHub Actions or other CI/CD systems. See the workflow files in `.github/workflows/` for examples.

### Sample GitHub Actions Integration

```yaml
- name: Run Tests
  run: |
    cd build
    ctest --output-on-failure
```

## Best Practices

1. **Keep tests focused** - Each test should verify one specific behavior
2. **Use descriptive names** - Test names should clearly indicate what is being tested
3. **Test edge cases** - Include tests for boundary conditions and error cases
4. **Maintain test data** - Use small, focused test datasets
5. **Document test expectations** - Comment complex test logic clearly

## Extending the Framework

The framework is designed to be extensible:

1. **Add new test types** - Create new subdirectories under `tests/`
2. **Add test utilities** - Create shared utility functions in the main CMakeLists.txt
3. **Add test data management** - Create subdirectories for test input/output data
4. **Add performance tests** - Extend with timing and performance verification

## Troubleshooting

### Common Issues

1. **Missing executables** - Ensure `make install` has been run before testing
2. **Timeout errors** - Increase timeout values for slow operations
3. **Library linking errors** - Ensure all required libraries are available and properly linked

### Debug Options

```bash
# Run with maximum verbosity
ctest -VV

# Run specific failing test
ctest -R "failing_test_name" -V

# Run tests and keep going on failure
ctest --force-new-ctest-process
```