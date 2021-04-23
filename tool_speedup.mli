(** The abstract type of values representing the speed_up tool
   with the duration, new speed*)
type t

val get_xy : t -> int * int

(** [show_tool1 b bkg] returns the list of position of tool_speedup
    bombed by the bomb*)
val show_tool1s : Bomb.t list -> Background.t -> (int * int) list

(** [new_speedups p b_lst bkg] *)
val new_speedups : Bomb.t list -> Background.t -> t list

val speedup_plr : t -> Player.t -> Player.t

val speedback_plr : t -> Player.t -> Player.t

val new_speedups_fromxy : (int * int) list -> t list
