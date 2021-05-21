(** Representation of tool of type 1 "Speed-up". *)

(** The abstract type of values representing the tool_speedup. *)
type t

(** [get_speedup_xy tool] returns the position of tool_speedup [tool]. *)
val get_speedup_xy : t -> int * int

(** [new_speedups_fromxy pos_lst] returns a list of tool_speedup from
    the position list [pos_lst]. *)
val new_speedups_fromxy : (int * int) list -> t list

(** [xy_to_speedup pos tool_lst] returns the tool_speedup that is
    located at position [pos] from the list of tool_speedup [tool_lst]. *)
val xy_to_speedup : int * int -> t list -> t

(** [speedup_plr tool plr] returns a player [plr] whose speed is changed
    by tool_speedup [tool]. *)
val speedup_plr : t -> Player.t -> Player.t
