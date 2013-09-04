program initialvalues
    print *, "SR1"
    call sr1()
    call sr1()

    print *, "SR2"
    call sr2()
    call sr2()

    print *, "SR3"
    call sr3()
    call sr3()
end program initialvalues

subroutine sr1()
    real :: x = 0
    x = x + 1
    print *, x
end subroutine

subroutine sr2()
    real :: x
    x = 0
    x = x + 1
    print *, x
end subroutine

subroutine sr3()
    real, save :: x
    logical :: first_time = .true.
    if (first_time) then
        x = 0
        first_time = .false.
    end if
    x = x + 1
    print *, x
end subroutine
