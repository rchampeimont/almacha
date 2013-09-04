module mult_scal_vect_module
    implicit none
contains
    subroutine mult_scal_vect(lambda, x, y, x2, y2)
        real, intent(in) :: lambda, x, y
        real, intent(out) :: x2, y2
        x2 = lambda * x
        y2 = lambda * y
    end subroutine
end module

program tests2
    implicit none

    interface
       subroutine sr(x)
         implicit none
         integer, intent(in) :: x
       end subroutine sr
    end interface    

    logical :: l
    integer :: dummy



    l = .true.
    if (l) then
        if (l) print *, "YES"
    end if

    call sr(dummy)
    call sr(4) ! wrong type

end program

subroutine sr(zz)
    use tests
    use mult_scal_vect_module
    implicit none
    real, parameter :: x0 = 1.0, y0 = 2.0
    real :: x, y
    integer :: A
    integer, intent(out) :: zz
    10000 format ("Science is truth for life. In Fortran tongue the answer. ", I2)

    A = the_answer()
    print 10000, A

    call mult_scal_vect(10.0, x0, 4.0, x, y)
    print *, x, y

    zz = 42
end subroutine

