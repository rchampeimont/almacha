program kinds
    implicit none
    integer, parameter :: max_p = 100, max_r = 10000
    integer :: k, last_k = -1
    integer :: r, p
    100 format ("P=",I2,"  R=",I4,"  Kind=",I2)

    last_k = -1
    r = 0
    do p = 1, max_p
        k = selected_real_kind(p, r)
        if (k /= last_k) then
            write (unit=*,fmt=100) p, r, k
        end if
        last_k = k
    end do

    last_k = -1
    p = 0
    do r = 1, max_r
        k = selected_real_kind(p, r)
        if (k /= last_k) then
            write (unit=*,fmt=100) p, r, k
        end if
        last_k = k
    end do

end program
