module testomp1_module
    implicit none
    save
contains
    function sum_real_array(A, B)
        use omp_lib
        implicit none
        integer :: i
        real, intent(in), dimension(:) :: A, B
        real, dimension(size(A)) :: sum_real_array
        if (size(A) /= size(B)) then
            print *, "Error : A and B have different sizes (", &
                size(A), "/=", size(B), ")"
            stop
        end if
        !$omp parallel do
        do i = 1, size(A)
            print *, "Process ", omp_get_thread_num(), " is doing cell ", i, "."
            sum_real_array(i) = A(i) + B(i)
        end do
        !$omp end parallel do
    end function
end module

program testomp1
    use testomp1_module
    use omp_lib
    implicit none
    integer :: i
    real, dimension(5) :: A, B, C

    call omp_set_num_threads(2)

    A = (/ (i, i = 1, size(A)) /)
    B = (/ (100*i, i = 1, size(A)) /)
    C = sum_real_array(A, B)

    print *, "A = ", A
    print *, "B = ", B
    print *, "C = ", C




end program

