program array_functions_test
    use array_functions
    implicit none
    integer, parameter :: n = 8
    real, dimension(-100:n-100) :: A
    real, dimension(size(A)+1) :: B
    real, dimension(size(A)-1) :: C
    integer :: k

    A = (/ (2**k, k=0,n) /)

    call copy_real_array(A, B)
    print *, "A = ", A
    print *, "B = ", B
    call copy_real_array(A, C)
    print *, "C = ", C

end program array_functions_test
