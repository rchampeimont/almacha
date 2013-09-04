let fact n =
    let rec f acc = function
        | n when n = 1I -> acc
        | n -> f (n*acc) (n-1I)
    in
    f 1I n

printfn "%s" (string (fact 365I))
