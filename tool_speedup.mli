(** The abstract type of values representing the speed_up tool
   with the duration, new speed*)
type t

(** [show_tool1 b bkg] returns the list of position of tool_speedup
    bombed by the bomb*)
val show_tool1s : Bomb.t list -> Background.t -> (int * int) list
