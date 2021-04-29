type t

val get_addheart_xy : t -> int * int

val xy_to_addheart : int * int -> t list -> t

(** [show_tool1 b bkgs] returns the list of position of tool_speedup
    bombed by the bomb*)
val show_tool2s : Bomb.t list -> Background.t -> (int * int) list

(** [new_speedups p b_lst bkg] *)
val new_addhearts : Bomb.t list -> Background.t -> t list

val new_addhearts_fromxy : (int * int) list -> t list
