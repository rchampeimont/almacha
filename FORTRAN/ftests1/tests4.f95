program tests4
    real :: x
    integer :: i
    real, dimension(:), allocatable :: bigtable

    interface
        subroutine add(v, x)
            real, intent(inout) :: v
            real, intent(in), optional :: x
        end subroutine
    end interface



    x = 4
    call add(x, 100.0)
    call add(x)
    print *, "x = ", x



    print *, "before allocate"
    allocate(bigtable(2000000000), stat=i)
    print *, "i = ", i
    print *, "after allocate"

    print *, "before allocate"
    allocate(bigtable(2000000000))
    print *, "after allocate"

end program tests4

subroutine add(v, x)
    real, intent(inout) :: v
    real, intent(in), optional :: x
    if (present(x)) then
        v = v + x
    else
        v = v + 1
    end if
end subroutine
