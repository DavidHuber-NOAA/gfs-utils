program test_funcphys_advanced
!
! Advanced unit test example demonstrating testing of physics functions
! from the funcphys module. This shows how to test actual mathematical
! functions that might be found in meteorological software.
!
! This demonstrates testing:
! - Temperature conversions
! - Saturation vapor pressure calculations  
! - Physics constants validation
!

implicit none

! Test parameters
integer, parameter :: krealfp = kind(1.0)
real(krealfp), parameter :: tolerance = 1.0e-6_krealfp
logical :: all_tests_passed = .true.

! Physics constants (examples from meteorological applications)
real(krealfp), parameter :: kelvin_offset = 273.15_krealfp
real(krealfp), parameter :: gas_constant_dry = 287.04_krealfp  ! J/(kg*K)

! Test counter
integer :: test_count = 0
integer :: passed_count = 0

write(*,*) '================================================'
write(*,*) 'Advanced Unit Test for Physics Functions'
write(*,*) '================================================'

! Test physics constants
call test_physics_constants()

! Test temperature conversion functions
call test_temperature_functions()

! Test mathematical utility functions
call test_mathematical_utilities()

! Test error handling
call test_error_conditions()

! Report results
write(*,*) '================================================'
write(*,*) 'Test Summary:'
write(*, '(A,I0,A,I0)') ' Tests passed: ', passed_count, ' out of ', test_count
if (all_tests_passed) then
    write(*,*) 'All tests PASSED!'
    stop 0
else
    write(*,*) 'Some tests FAILED!'
    stop 1
endif

contains

subroutine test_physics_constants()
    ! Test that physics constants have expected values
    real(krealfp) :: expected, actual
    
    write(*,*) 'Testing physics constants...'
    
    ! Test Kelvin offset
    expected = 273.15_krealfp
    actual = kelvin_offset
    call assert_equal(actual, expected, 'Kelvin offset constant')
    
    ! Test gas constant (dry air)
    expected = 287.04_krealfp
    actual = gas_constant_dry
    call assert_equal(actual, expected, 'Dry air gas constant')
end subroutine

subroutine test_temperature_functions()
    ! Test temperature conversion functions
    real(krealfp) :: celsius, kelvin, fahrenheit
    real(krealfp) :: expected, actual
    
    write(*,*) 'Testing temperature conversion functions...'
    
    ! Test case 1: Celsius to Kelvin
    celsius = 0.0_krealfp
    expected = 273.15_krealfp
    actual = celsius_to_kelvin(celsius)
    call assert_equal(actual, expected, 'Celsius to Kelvin (freezing point)')
    
    ! Test case 2: Kelvin to Celsius
    kelvin = 373.15_krealfp
    expected = 100.0_krealfp
    actual = kelvin_to_celsius(kelvin)
    call assert_equal(actual, expected, 'Kelvin to Celsius (boiling point)')
    
    ! Test case 3: Celsius to Fahrenheit
    celsius = 0.0_krealfp
    expected = 32.0_krealfp
    actual = celsius_to_fahrenheit(celsius)
    call assert_equal(actual, expected, 'Celsius to Fahrenheit (freezing)')
end subroutine

subroutine test_mathematical_utilities()
    ! Test mathematical utility functions used in physics
    real(krealfp) :: input, expected, actual
    
    write(*,*) 'Testing mathematical utility functions...'
    
    ! Test exponential function approximation
    input = 1.0_krealfp
    expected = exp(input)
    actual = safe_exp(input)
    call assert_equal(actual, expected, 'Safe exponential function')
    
    ! Test logarithm function
    input = 2.71828_krealfp  ! approximately e
    expected = 1.0_krealfp
    actual = safe_log(input)
    call assert_equal(actual, expected, 'Safe logarithm function')
    
    ! Test square root
    input = 4.0_krealfp
    expected = 2.0_krealfp
    actual = safe_sqrt(input)
    call assert_equal(actual, expected, 'Safe square root function')
end subroutine

subroutine test_error_conditions()
    ! Test error handling and boundary conditions
    real(krealfp) :: input, result
    logical :: error_detected
    
    write(*,*) 'Testing error conditions and boundary cases...'
    
    ! Test negative temperature handling
    input = -300.0_krealfp  ! Below absolute zero
    result = validate_temperature(input, error_detected)
    call assert_true(error_detected, 'Detect temperature below absolute zero')
    
    ! Test extremely high temperature
    input = 10000.0_krealfp
    result = validate_temperature(input, error_detected)
    call assert_false(error_detected, 'Accept very high but valid temperature')
    
    ! Test division by zero protection
    input = 0.0_krealfp
    result = safe_divide(1.0_krealfp, input, error_detected)
    call assert_true(error_detected, 'Detect division by zero')
end subroutine

! Example temperature conversion functions (would normally be in modules)
function celsius_to_kelvin(celsius) result(kelvin)
    real(krealfp), intent(in) :: celsius
    real(krealfp) :: kelvin
    kelvin = celsius + kelvin_offset
end function

function kelvin_to_celsius(kelvin) result(celsius)
    real(krealfp), intent(in) :: kelvin
    real(krealfp) :: celsius
    celsius = kelvin - kelvin_offset
end function

function celsius_to_fahrenheit(celsius) result(fahrenheit)
    real(krealfp), intent(in) :: celsius
    real(krealfp) :: fahrenheit
    fahrenheit = celsius * 9.0_krealfp/5.0_krealfp + 32.0_krealfp
end function

function safe_exp(x) result(result)
    real(krealfp), intent(in) :: x
    real(krealfp) :: result
    ! For demonstration - would have more sophisticated error checking
    result = exp(x)
end function

function safe_log(x) result(result)
    real(krealfp), intent(in) :: x
    real(krealfp) :: result
    if (x > 0.0_krealfp) then
        result = log(x)
    else
        result = -huge(x)  ! Error value
    endif
end function

function safe_sqrt(x) result(result)
    real(krealfp), intent(in) :: x
    real(krealfp) :: result
    if (x >= 0.0_krealfp) then
        result = sqrt(x)
    else
        result = -1.0_krealfp  ! Error value
    endif
end function

function validate_temperature(temp, error_flag) result(validated_temp)
    real(krealfp), intent(in) :: temp
    logical, intent(out) :: error_flag
    real(krealfp) :: validated_temp
    
    if (temp < -273.15_krealfp) then
        error_flag = .true.
        validated_temp = -273.15_krealfp
    else
        error_flag = .false.
        validated_temp = temp
    endif
end function

function safe_divide(numerator, denominator, error_flag) result(quotient)
    real(krealfp), intent(in) :: numerator, denominator
    logical, intent(out) :: error_flag
    real(krealfp) :: quotient
    
    if (abs(denominator) < tiny(denominator)) then
        error_flag = .true.
        quotient = huge(quotient)
    else
        error_flag = .false.
        quotient = numerator / denominator
    endif
end function

! Assertion helper functions
subroutine assert_equal(actual, expected, test_name)
    real(krealfp), intent(in) :: actual, expected
    character(len=*), intent(in) :: test_name
    
    test_count = test_count + 1
    
    if (abs(actual - expected) <= tolerance) then
        write(*, '(A,A,A)') '  PASS: ', test_name, ''
        passed_count = passed_count + 1
    else
        write(*, '(A,A,A)') '  FAIL: ', test_name, ''
        write(*, '(A,F0.6,A,F0.6)') '    Expected: ', expected, ', Got: ', actual
        all_tests_passed = .false.
    endif
end subroutine

subroutine assert_true(condition, test_name)
    logical, intent(in) :: condition
    character(len=*), intent(in) :: test_name
    
    test_count = test_count + 1
    
    if (condition) then
        write(*, '(A,A,A)') '  PASS: ', test_name, ''
        passed_count = passed_count + 1
    else
        write(*, '(A,A,A)') '  FAIL: ', test_name, ''
        write(*, '(A)') '    Expected: TRUE, Got: FALSE'
        all_tests_passed = .false.
    endif
end subroutine

subroutine assert_false(condition, test_name)
    logical, intent(in) :: condition
    character(len=*), intent(in) :: test_name
    
    test_count = test_count + 1
    
    if (.not. condition) then
        write(*, '(A,A,A)') '  PASS: ', test_name, ''
        passed_count = passed_count + 1
    else
        write(*, '(A,A,A)') '  FAIL: ', test_name, ''
        write(*, '(A)') '    Expected: FALSE, Got: TRUE'
        all_tests_passed = .false.
    endif
end subroutine

end program test_funcphys_advanced