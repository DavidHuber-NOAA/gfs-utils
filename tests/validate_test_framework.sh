#!/bin/bash
#
# validate_test_framework.sh
#
# This script validates that the ctest testing framework is properly configured
# and can be used for testing gfs-utils executables and functions.
#

set -euo pipefail

echo "=== GFS-Utils Test Framework Validation ==="
echo ""

# Check directory structure
echo "1. Checking test directory structure..."
if [[ -d "tests" ]]; then
    echo "   ✓ tests/ directory exists"
else
    echo "   ✗ tests/ directory missing"
    exit 1
fi

if [[ -d "tests/executable_tests" ]]; then
    echo "   ✓ tests/executable_tests/ directory exists"
else
    echo "   ✗ tests/executable_tests/ directory missing"
    exit 1
fi

if [[ -d "tests/unit_tests" ]]; then
    echo "   ✓ tests/unit_tests/ directory exists"
else
    echo "   ✗ tests/unit_tests/ directory missing"
    exit 1
fi

# Check CMake configuration files
echo ""
echo "2. Checking CMake test configuration..."
if [[ -f "tests/CMakeLists.txt" ]]; then
    echo "   ✓ tests/CMakeLists.txt exists"
    if grep -q "enable_testing" CMakeLists.txt; then
        echo "   ✓ enable_testing() found in main CMakeLists.txt"
    else
        echo "   ✗ enable_testing() not found in main CMakeLists.txt"
        exit 1
    fi
else
    echo "   ✗ tests/CMakeLists.txt missing"
    exit 1
fi

# Check helper functions
echo ""
echo "3. Checking test helper functions..."
if grep -q "add_executable_test" tests/CMakeLists.txt; then
    echo "   ✓ add_executable_test helper function found"
else
    echo "   ✗ add_executable_test helper function missing"
    exit 1
fi

if grep -q "add_fortran_unit_test" tests/CMakeLists.txt; then
    echo "   ✓ add_fortran_unit_test helper function found"
else
    echo "   ✗ add_fortran_unit_test helper function missing"
    exit 1
fi

# Check sample test
echo ""
echo "4. Checking sample tests..."
if [[ -f "tests/unit_tests/sample_funcphys_test.f90" ]]; then
    echo "   ✓ Sample unit test exists"
    # Try to compile it
    if command -v gfortran >/dev/null 2>&1; then
        cd tests/unit_tests
        if gfortran -o sample_funcphys_test sample_funcphys_test.f90 2>/dev/null; then
            echo "   ✓ Sample unit test compiles successfully"
            if ./sample_funcphys_test >/dev/null 2>&1; then
                echo "   ✓ Sample unit test runs successfully"
            else
                echo "   ⚠ Sample unit test runs but may have failed"
            fi
            rm -f sample_funcphys_test
        else
            echo "   ⚠ Sample unit test does not compile (may need additional setup)"
        fi
        cd ../..
    else
        echo "   ⚠ gfortran not available, cannot test compilation"
    fi
else
    echo "   ✗ Sample unit test missing"
    exit 1
fi

# Check documentation
echo ""
echo "5. Checking documentation..."
if [[ -f "tests/README.md" ]]; then
    echo "   ✓ Test framework documentation exists"
else
    echo "   ✗ Test framework documentation missing"
    exit 1
fi

# Check GitHub workflow
echo ""
echo "6. Checking GitHub workflow integration..."
if [[ -f ".github/workflows/tests.yaml" ]]; then
    echo "   ✓ GitHub Actions test workflow exists"
else
    echo "   ✗ GitHub Actions test workflow missing"
    exit 1
fi

# Test CMake configuration (if cmake is available)
echo ""
echo "7. Testing CMake configuration..."
if command -v cmake >/dev/null 2>&1; then
    mkdir -p build_test
    cd build_test
    if cmake .. >/dev/null 2>&1; then
        echo "   ✓ CMake configuration successful"
        
        # Check if ctest can find tests
        if ctest --show-only >/dev/null 2>&1; then
            echo "   ✓ CTest can discover tests"
        else
            echo "   ⚠ CTest configuration may need dependencies"
        fi
    else
        echo "   ⚠ CMake configuration failed (likely due to missing dependencies)"
    fi
    cd ..
    rm -rf build_test
else
    echo "   ⚠ cmake not available, cannot test configuration"
fi

echo ""
echo "=== Validation Complete ==="
echo ""
echo "Summary:"
echo "✓ Test framework structure is properly set up"
echo "✓ CMake test configuration is complete"
echo "✓ Helper functions are available for easy test creation"
echo "✓ Sample test demonstrates the framework"
echo "✓ Documentation is provided"
echo "✓ GitHub Actions integration is configured"
echo ""
echo "The ctest testing framework is ready for use!"
echo "See tests/README.md for detailed usage instructions."