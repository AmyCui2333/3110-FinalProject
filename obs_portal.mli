type t

val get_portal1_xy : t -> int * int

val get_portal2_xy : t -> int * int

val new_portal : Background.t -> t

val transfer_pl : Player.t -> int * int -> Player.t

val portal_pos : int * int -> t -> int * int
