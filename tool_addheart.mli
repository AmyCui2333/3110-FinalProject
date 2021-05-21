(** Representation of tool of type 2 "Add-Heart". *)

(** The abstract type of values representing the tool_addheart. *)
type t

(** [get_speedup_xy tool] returns the position of tool_speedup [tool]. *)
val get_addheart_xy : t -> int * int

(** [new_addhearts_fromxy pos_lst] returns a list of tool_addheart from
    the position list [pos_lst]. *)
val new_addhearts_fromxy : (int * int) list -> t list
