(** Representation of tool of type 3 "Big-Bomb-Up". *)

(** The abstract type of values representing the ToolAddBomb. *)
type t

(** [get_bomb_xy tool] returns the position of ToolAddBomb [tool]. *)
val get_bomb_xy : t -> int * int

(** [new_addbombs_fromxy pos_lst] returns a list of ToolAddBomb from the
    position list [pos_lst]. *)
val new_addbombs_fromxy : (int * int) list -> t list

(** [bombup_plr plr] returns a player [plr] whose bomb power is
    increased by ToolAddBomb. *)
val bombup_plr : Player.t -> Player.t
