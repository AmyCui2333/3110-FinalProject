(** Representation of tool of type 2 "Add-Heart". *)

(** The abstract type of values representing the tool_addheart. *)
type t

(** [get_speedup_xy tool] returns the position of tool_speedup [tool]. *)
val get_addheart_xy : t -> int * int

(** [show_tool2 b_lst bkg] returns a list of tool_addheart's positions
    in the background map [bkg]; all tool_addheart in the returned list
    were hidden in bushes before exploded by bombs listed in [b_lst]. *)
val show_tool2s : Bomb.t list -> Background.t -> (int * int) list

(** [new_addhearts_fromxy pos_lst] returns a list of tool_addheart from
    the position list [pos_lst]. *)
val new_addhearts_fromxy : (int * int) list -> t list
