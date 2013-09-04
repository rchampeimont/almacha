program input
    implicit none
    real x, y, z, t
    real A(2)
    integer i, j
    100 format (I4,I4)
    x = 42.3456
    y = 1.1
    z = 14.545458043e20
    t = 0.0000000000001

    read '(F8.0)', A

    print *, A


end program input

subroutine print_real(x)
    implicit none
    real, intent(in) :: x
    print '(E10.3)', x
    print '(F10.3)', x
    print *, x
    write (unit=6, fmt=*) x
end
