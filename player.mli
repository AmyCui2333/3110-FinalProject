(** Representation of static background type.

    This module represents the data used to represent players. *)

(** The abstract type of values representing players. *)
type t

(** The type of player ids. *)
type player_id = string

(** The type of coordinates of player *)
type xy = int * int

(** [start_tile] is the identifier of the starting tile in the game. *)
val curr_pos : t -> xy

(** [get_speed p] gets the current speed of player p. *)
val get_speed : t -> int

(** [speed_up p s] increases the speed of player p by s and returns the
    new player. *)
val speed_up : t -> int -> t

(** [lives p] gets the current remaining lives of player p *)
val lives : t -> int

(** [kill p] decreases the remaining lives of player p by 1 and returns
    the new player*)
val kill : t -> t

(* (** [move_up p] moves the player up by one unit if there is nothing
   blocking the player, returns the new player*) val move_up : t -> t

   (** [move_down p] moves the player down by one unit if there is
   nothing blocking the player*) val move_down : t -> t

   (** [move_left p] moves the player to the left by one unit if there
   is nothing blocking the player*) val move_left : t -> t

   (** [move_right p] moves the player to the right by one unit if there
   is nothing blocking the player*) val move_right : t -> t *)
