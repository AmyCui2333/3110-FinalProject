(** This module represents the data used to represent players. *)

(** The abstract type of values representing players. *)

type t

type direction =
  | LEFT
  | RIGHT
  | UP
  | DOWN

val slow_speed : int

val fast_speed : int

val enemy_pos : t -> int * int

val enemy_speed : t -> int

val build_enemy : int * int -> (int * int) list -> string -> t

val get_direction : Player.t -> t -> direction list

val move_enemy : direction list -> Background.t -> t -> t

val collide_with_player : Player.t -> t -> Player.t * t option
