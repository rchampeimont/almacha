program concat_array_test
    use concat_array_module
    implicit none
    real, dimension(0:2) :: X
    real, dimension(5) :: Y
    integer :: i
    X = (/ (i+1, i=0,size(X)-1) /)
    Y = (/ (10*i, i=4,4+size(Y)-1) /)

    print *, concat_real_array(X, Y)

end program concat_array_test
