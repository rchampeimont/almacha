      PROGRAM MAX

      REAL T(1:5)
      REAL T2(1:5)
      T = (/ 0.0, -1.5, 67E4, -78E23, 88.0 /)

      WRITE (*,*) "T"
      DO 10 I = 1,5
 10     WRITE (*,*) T(I)

      T2 = sin(T)
      WRITE (*,*) "T2"
      DO 20 I = 1,5
 20     WRITE (*,*) T2(I)

      M = T(1)
      DO 35 I = 2,5
        IF (T(I) - M) 35, 35, 30
 30     M = T(I)
 35     CONTINUE

      PRINT *, "Le maximum dans T est :"
      WRITE (*,*) M

      END PROGRAM MAX
