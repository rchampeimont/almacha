program recursive1
    integer :: i

    do i = 0, 5
        call print_fact(i)
    end do
end program

subroutine print_fact(n)
    interface
        integer function fact(n)
            integer n
        end function
    end interface
    integer, intent(in) :: n
    100 format ("fact(",I1,") = ", I4)
    print 100, n, fact(n)
end subroutine

integer function fact(n)
    integer, intent(in) :: n

    if (n < 0) then
        stop
    end if

    fact = fact_aux(n)

    contains
        integer recursive function fact_aux(m) result(r)
            integer, intent(in) :: m

            if (m == 0) then
                r = 1
            else
                r = m * fact_aux(m - 1)
            end if
        end function
end function
