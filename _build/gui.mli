(**[draw_background t] draws the initial backghround specified in [t] of
   the gram with all files with no obstacles or players*)

(* val draw_background : Background.t -> unit *)

(**[draw_player p] draws the players epecified in [p] of the grame on
   the background on the initial position and moves the players around*)

(* val draw_player: Player.t -> unit *)

(**[draw_bomb b] draws the bomb [b] placed by the player and the
   animation of bombing*)

(* val draw_bomb : State.t -> unit *)

val draw_canvas : unit -> unit

val draw_bkg : unit -> unit

val draw_obs : Background.t -> unit

val init_p1_xy : string -> int * int

val draw_plr1 : int * int -> unit

val draw_plr2 : int * int -> unit

val draw_state : State.t -> unit

(* val move : State.t -> unit *)

(* val input : State.t -> unit *)

val draw_move : State.t -> int * int -> int * int -> unit
