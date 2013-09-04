program matrix
    real, dimension(:,:), allocatable :: M
    real, dimension(:), allocatable :: maxs
    integer :: i, j
     90 format ("M                                            MAX")
    100 format ("    ", 4F12.4)
    110 format ("MAX ", 4F12.4)

    call init_random_seed()

    allocate(M(3,3))
    allocate(maxs(3))

    call random_number(M)
    M = 100 * M
    maxs = maxval(M,2)
    print 90
    do i = lbound(M,1), ubound(M,1)
        print 100, (/ (M(i,j), j=lbound(M,2), ubound(M,2)) /), maxs(i)
    end do
    maxs = maxval(M,1)
    print 110, maxs, maxval(maxs)

    deallocate(M)
    deallocate(maxs)
end program

! Stolen from RANDOM_SEED man in gfortran
SUBROUTINE init_random_seed()
    INTEGER :: i, n, clock
    INTEGER, DIMENSION(:), ALLOCATABLE :: seed

    CALL RANDOM_SEED(size = n)
    ALLOCATE(seed(n))

    CALL SYSTEM_CLOCK(COUNT=clock)

    seed = clock + 37 * (/ (i - 1, i = 1, n) /)
    CALL RANDOM_SEED(PUT = seed)

    DEALLOCATE(seed)
END SUBROUTINE
