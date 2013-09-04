program tests3
    real :: x, y, z
    interface
        real function apply_right_function(a, b)
            integer :: a
            real :: b
        end function
    end interface

    z = 10
    x = apply_right_function(1, z)
    y = apply_right_function(2, z)

    print *, "x = ", x
    print *, "y = ", y
end program

real function apply_right_function(which, arg)
    integer :: which
    real :: arg
    interface
        real function one(x)
            real, intent(in) :: x
        end function
        real function two(x)
            real, intent(in) :: x
        end function
        real function apply(f, x)
            real, intent(in) :: x
            real, external :: f
        end function
    end interface
    if (which /= 1) then
        apply_right_function = apply(two, arg)
    else
        apply_right_function = apply(one, arg)
    end if
end function

real function one(x)
    real, intent(in) :: x
    one = x + 1
end function

real function two(y)
    real, intent(in) :: y
    two = y + 2
end function

real function apply(f, x)
    real, intent(in) :: x
    real, external :: f
    apply = f(x)
end function

