program output
    implicit none
    integer :: i, j

    print *, "begin program"

    open (unit=42, file="a.txt")
    write (42, *) "fist line"
    write (42, *) "second line"
    endfile 42
    write (42, *) "after line"

    write (6,*) "end program"

end program output
