type t

val get_bomb_xy : t -> int * int

(* val xy_to_addbomb : int * int -> t list -> t *)

(** [show_tool1 b bkgs] returns the list of position of tool_speedup
    bombed by the bomb*)
val show_tool3s : Bomb.t list -> Background.t -> (int * int) list

val bombup_plr : Player.t -> Player.t

(** [new_speedups p b_lst bkg] *)

(* val new_addbombs : Bomb.t list -> Background.t -> t list *)

(* val speedup_plr : t -> Player.t -> Player.t *)

(* val speedback_plr : t -> Player.t -> Player.t *)

val new_addbombs_fromxy : (int * int) list -> t list
