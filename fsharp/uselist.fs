let my_print_list (l : int list) =
    let g s =
        System.Console.WriteLine (s : int)
    in
    List.iter g l


my_print_list [1;2;3;4]

