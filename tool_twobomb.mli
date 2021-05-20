type t

val get_twobomb_xy : t -> int * int

val show_tool4s : Bomb.t list -> Background.t -> (int * int) list

val new_twobombs_fromxy : (int * int) list -> t list
