(** The abstract type of values representing the game state.  type t*)
type t 
   (** [start_state bkg] is the starting state where the gamer is located in when
       playing background [bkg]. In that state the player is currently located in
       the starting point. *)
    val start_state : Background.t -> t
