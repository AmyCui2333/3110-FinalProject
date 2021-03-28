(** The abstract type of values representing the game state. 
   type t*)
type t

(**[init_state bkg pos1 pos2] is the starting state where the gamer is located in when
   playing background [bkg]. In that state the player is currently located in
   the starting point. *)
val init_state : Background.t -> Player.xy -> Player.xy -> t

(**[player_one t] returns the player_one object. *)
val player_one : t -> Player.t

(**[player_one t] returns the player_one object. *)
val player_two : t -> Player.t
