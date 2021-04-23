(** The abstract type of values representing the game state. 
   type t*)
type t

type input =
  | Legal of t
  | Make_bomb of t
  | Exit

(**[init_state bkg pos1 pos2] is the starting state where the gamer is located 
   in when
   playing background [bkg]. In that state the player is currently 
   located in the starting point. *)

(* val init_state : Background.t -> Player.xy -> Player.xy -> t *)

val init_state : Background.t -> Player.xy -> t

val get_bkg : t -> Background.t

(**[player_one t] returns the player_one object. *)
val player_one : t -> Player.t

(**[player_one t] returns the player_one object. *)

(* val player_two : t -> Player.t *)

(**[move_player_one p] returns a new state after updating player one to
   p *)
val move_player_one : t -> Player.t -> t

(**[move_player_two p] returns a new state after updating player two to
   p *)

(* val move_player_two : t -> Player.t -> t *)

val take_input : t -> input

(** [change_bkg st b] returns the state with bkg [b]*)
val change_bkg : t -> Background.t -> t

(** [add_bomb b st] adds one bomb into the st*)
val add_bomb : Bomb.t -> t -> t

val some_explosion : t -> bool

(** [clear_explode st] updates the [st] with the new background after
    explosion (if any) and the bombs left*)
val clear_exploding : t -> t

(** [exploding st] returns the bombs to be exploded (when reaching the
    time of explosion)*)
val exploding : t -> Bomb.t list
