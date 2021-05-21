(** This module represents the data used to represent enemies. *)

(** The abstract type of values representing enemies. *)
type t

(** The abstract type of values representing the direction in which the
    enemy should move. *)
type direction =
  | LEFT
  | RIGHT
  | UP
  | DOWN

(** The speed value of a slow type enemy. *)
val slow_speed : int

(** The speed value of a fast type enemy. *)
val fast_speed : int

(** [enemy pos e] gets the current position of the enemy [e]. *)
val enemy_pos : t -> int * int

(** [build_enemy pos off_tiles enemy_type] initializes an enemy of type
    [enemy_type] at position [pos], with [off_tiles] as tile he cannot
    step on. *)
val build_enemy : int * int -> (int * int) list -> string -> t

(** [enemy_speed e] gets the current speed of enemy [e]. *)
val enemy_speed : t -> int

(** [get_direction p] gets a list of directions in descending priority
    that the enemy should try based on player [p]. *)
val get_direction : Player.t -> t -> direction list

(** [move_enemy dir_list] goes through [dir_list] and updates the
    enemy's position using the first direction without obstacles. *)
val move_enemy : direction list -> Background.t -> t -> t

(** [collide_with_player p e] determines whether player [p] collides
    with enemy [e], and returns the updated player and enemy. *)
val collide_with_player : Player.t -> t -> Player.t * t option
