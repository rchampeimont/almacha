program modernmax
    implicit none
    integer :: i
    real :: T(5)
    real :: max

    T = (/ 0.0, -1.5, 67E4, -78E23, 88.0 /)

    max = T(1)
    do i = 2, size(T)
        if (T(i) > max) then
            max = T(i)
        end if
    end do

    print *, "Max = ", max

end program modernmax
