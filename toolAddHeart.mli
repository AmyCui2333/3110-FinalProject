(** Representation of tool of type 2 "Add-Heart". *)

(** The abstract type of values representing the ToolAddHeart. *)
type t

(** [get_speedup_xy tool] returns the position of ToolSpeedUp [tool]. *)
val get_addheart_xy : t -> int * int

(** [new_addhearts_fromxy pos_lst] returns a list of ToolAddHeart from
    the position list [pos_lst]. *)
val new_addhearts_fromxy : (int * int) list -> t list
