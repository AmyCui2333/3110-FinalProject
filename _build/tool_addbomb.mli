(** Representation of tool of type 3 "Big-Bomb-Up". *)

(** The abstract type of values representing the tool_addbomb. *)
type t

(** [get_bomb_xy tool] returns the position of tool_addbomb [tool]. *)
val get_bomb_xy : t -> int * int

(** [show_tool3s b_lst bkg] returns a list of tool_addbomb's positions
    in the background map [bkg]; all tool_addbomb in the returned list
    were hidden in bushes before exploded by bombs listed in [b_lst]. *)
val show_tool3s : Bomb.t list -> Background.t -> (int * int) list

(** [new_addbombs_fromxy pos_lst] returns a list of tool_addbomb from
    the position list [pos_lst]. *)
val new_addbombs_fromxy : (int * int) list -> t list

(** [bombup_plr plr] returns a player [plr] whose bomb power is
    increased by tool_addbomb. *)
val bombup_plr : Player.t -> Player.t
