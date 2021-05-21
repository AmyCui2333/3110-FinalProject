(** Representation of tool of type 4 "Double-Bombs". *)

(** The abstract type of values representing the tool_twobomb. *)
type t

(** [get_twobomb_xy tool] returns the position of tool_twobomb [tool]. *)
val get_twobomb_xy : t -> int * int

(** [show_tool4s b_lst bkg] returns a list of tool_twobomb's positions
    in the background map [bkg]; all tool_twobomb in the returned list
    were hidden in bushes before exploded by bombs listed in [b_lst]. *)
val show_tool4s : Bomb.t list -> Background.t -> (int * int) list

(** [new_twobombs_fromxy pos_lst] returns a list of tool_twobomb from
    the position list [pos_lst]. *)
val new_twobombs_fromxy : (int * int) list -> t list
