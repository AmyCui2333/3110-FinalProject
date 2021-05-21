(** Representation of static background type.
    This module represents the data used to represent players. *)

(** The abstract type of values representing the player. *)
type t

(** The type of player ids. *)
type player_type = string

(** The type of coordinates of player *)
type xy = int * int

val tile_size : int

val tile_number : int

val move_number : int

(** [build_player ply_type curr_pos] initializes a player *)
val build_player : player_type -> xy -> t

val get_power : t -> int

(** [get_plr_type plr] returns the player's type as either lama or camel *)
val get_plr_type : t -> player_type

(** [start_tile] is the identifier of the starting tile in the game. *)
val curr_pos : t -> xy

(** [get_speed p] gets the current speed of player p. *)
val get_speed : t -> int

val change_speed : t -> int -> t

val get_bomb : t -> int

val change_bomb : t -> int -> t

val  change_pl_pos : t -> (int * int)-> t

(** [lives p] gets the current remaining lives of player p *)
val lives : t -> int

(** [kill p] decreases the remaining lives of player p by 1 and returns
    the new player*)
val kill : t -> t

val add : t -> t
(** [move_up p] moves the player up by one unit if there is nothing
    blocking the player, returns the new player*)
val move_up : t -> t

(** [move_down p] moves the player down by one unit if there is nothing
    blocking the player*)
val move_down : t -> t

(** [move_left p] moves the player to the left by one unit if there is
    nothing blocking the player*)
val move_left : t -> t

(** [move_right p] moves the player to the right by one unit if there is
    nothing blocking the player*)
val move_right : t -> t

(* val no_collision_up : Background.t -> t -> t -> t *)
val no_collision_up : Background.t -> t -> t

(* val no_collision_down : Background.t -> t -> t -> t *)
val no_collision_down : Background.t -> t -> t

(* val no_collision_left : Background.t -> t -> t -> t *)
val no_collision_left : Background.t -> t -> t

(* val no_collision_right : Background.t -> t -> t -> t *)
val no_collision_right : Background.t -> t -> t

val tool_collision_right : int * int -> t -> bool

val tool_collision_left : int * int -> t -> bool

val tool_collision_up : int * int -> t -> bool

val tool_collision_down : int * int -> t -> bool

val tool_collision : int * int -> t -> bool

val tools_collision : (int * int) list -> t -> bool

val tools_collision_return : (int * int) list -> t -> bool * (int * int)

val tool_collision_gui : int * int -> t -> bool

val tools_collision_gui_return :
  (int * int) list -> t -> bool * (int * int)

val ( <+> ) :
  bool * (int * int) -> bool * (int * int) -> bool * (int * int)

val tool_collision_right_gui : int * int -> t -> bool

val tool_collision_left_gui : int * int -> t -> bool

val tool_collision_up_gui : int * int -> t -> bool

val tool_collision_down_gui : int * int -> t -> bool
