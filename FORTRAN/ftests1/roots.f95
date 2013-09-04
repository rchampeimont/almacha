PROGRAM roots
    IMPLICIT NONE
    REAL :: a, b, c, delta, x1, x2
    COMPLEX :: x1c, x2c

    PRINT *, "This programs computes the roots of a polynomial &
             &aX^2 + bX + c"
    PRINT *, "Please enter a, b, c in this order."
    READ *, a, b, c

    delta = b**2 - 4 * a * c
    IF (delta > 0.0) THEN
        x1 = (-b-sqrt(delta))/(2*a)
        x2 = (-b+sqrt(delta))/(2*a)
        PRINT *, "Solutions are ", x1, " and ", x2, "."
    ELSE IF (delta == 0.0) THEN
        x1 = -b / (2*a)
        PRINT *, "Solution is ", x1, "."
    ELSE
        x1c = (-b - (1.0,0.0)*sqrt(-delta))/(2*a)
        x2c = (-b + (1.0,0.0)*sqrt(-delta))/(2*a)
        PRINT *, "Complex solutions are ", x1c, " and ", x2c, "."
    END IF

END PROGRAM
