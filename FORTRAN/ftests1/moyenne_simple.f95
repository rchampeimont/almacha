program moyenne_simple
    implicit none
    integer :: i
    real :: T(5)
    real :: somme, moyenne

    T = (/ -10, 10, 0, 5, 10 /)

    somme = 0
    do i = 1, size(T)
        somme = somme + T(i)
    end do

    moyenne = somme / size(T)

    print *, "Moyenne = ", moyenne

end program
