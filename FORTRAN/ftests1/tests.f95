module tests
    implicit none
    integer :: internal_A

contains

    integer function the_answer()
        implicit none
        logical :: first_time = .true.
        if (first_time) then
            first_time = .false.
            internal_A = 42
        end if
        the_answer = internal_A
    end function

    subroutine s(a, b)
        real :: a, b
        a = b
    end subroutine

end module
