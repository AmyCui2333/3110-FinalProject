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

val change_bkg : t -> Background.t -> t

val add_bomb : Bomb.t -> t -> t

val some_explosion : t -> bool

val clear_exploding : t -> t

val exploding : t -> Bomb.t list
