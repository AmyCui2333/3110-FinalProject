(** Representation of tool of type 4 "Double-Bombs". *)

(** The abstract type of values representing the tool_twobomb. *)
type t

(** [get_twobomb_xy tool] returns the position of tool_twobomb [tool]. *)
val get_twobomb_xy : t -> int * int

(** [new_twobombs_fromxy pos_lst] returns a list of tool_twobomb from
    the position list [pos_lst]. *)
val new_twobombs_fromxy : (int * int) list -> t list
