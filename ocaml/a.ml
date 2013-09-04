module type Comparable =
sig
  type t
  val leq : t -> t -> bool
end

module ListSorter(T : Comparable) :
sig
  val sort : T.t list -> T.t list
end
=
struct
  let sort l =
    if T.leq (List.hd l) (List.hd l)
    then l
    else l
  let truc x = x
end

module IntComparable : Comparable with type t = int =
struct
  type t = int
  let leq = fun x y -> (x + 0) <= y
  let bidule y = y
end

module M = ListSorter(IntComparable)

let print_int_list l =
  List.iter (fun x -> Printf.printf "%d\n" x) l

let l = M.sort [1;3;4]

let _ =
  print_int_list l
