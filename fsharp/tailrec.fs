let rec f x =
    if x = 2000000000
    then x
    else f (x+1)

System.Console.WriteLine (f 0)

