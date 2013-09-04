module concat_array_module
    implicit none
contains
    ! This function returns an arrray of size size(a)+size(b) which contains
    ! the concatanation of a and b, in this order.
    function concat_real_array(a, b)
        implicit none
        real, intent(in), dimension(:) :: a
        real, intent(in), dimension(size(a)+1:) :: b
        real, dimension(size(a) + size(b)) :: concat_real_array
        integer :: i

        do i = 1, size(a)
            concat_real_array(i) = a(i)
        end do

        do i = size(a)+1, size(concat_real_array)
            concat_real_array(i) = b(i)
        end do
    end function
end module
