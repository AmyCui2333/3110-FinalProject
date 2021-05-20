(** Representation of bombs planted by the player *)

(** The abstract type of values representing the bomb with
   position, power, and start time*)
type t

(** [make_bomb p ] makes the bomb at the player's current position with
    the bomb_power initiated from player and record a start time of bomb *)
val make_bomb : Player.t -> t option

(** [get_neighbours pwr b lst] returns the position of all neighboring
    tiles affectted by the bomb, depending on the bomb's power [pwr] *)
val get_neighbours : int -> t -> (int * int) list -> (int * int) list

(** [check_explode b] returns true if it's time for the bomb [b] to de
    exploded else false*)
val check_explode : t -> bool

(** [explode bkg b_lst] explode all bombs in [b_lst] on the background.
    background stays the same if there's no bomb explosion*)
val explode : Background.t -> t list -> Background.t

(** [get_pos t] returns the postion of the bomb*)
val get_pos : t -> int * int

(** [in_blast_area b pos] returns true if position [pos] is within bomb [n]'s blast area *)
val in_blast_area : t -> int * int -> bool
(**[in_blast_lst bomb_list pos] returns true if position [pos] is within the blast area of any of the bombs in [bomb_list] *)
val in_blast_lst : t list -> int * int -> bool
