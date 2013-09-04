module array_functions
    implicit none
contains
    subroutine copy_real_array(from, to)
        implicit none
        real, intent(in), dimension(:) :: from
        real, intent(out), dimension(:) :: to
        integer :: i

        if (size(from) > size(to)) then
            print *, "Error : Destination array is too small (", &
                size(from), ">", size(to), ")"
            stop
        end if
        do i = 1,size(to)
            to(i) = from(i)
        end do
    end subroutine
end module array_functions
