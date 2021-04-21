type t

val make_bomb : Player.t -> t

val get_neighbours : t -> (int * int) list

val check_explode : t -> bool

val explode : Background.t -> t list -> Background.t

val get_pos : t -> int * int
