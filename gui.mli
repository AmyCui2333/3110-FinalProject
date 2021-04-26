(**[draw_background t] draws the initial backghround specified in [t] of
   the gram with all files with no obstacles or players*)

(* val draw_background : Background.t -> unit *)

(**[draw_player p] draws the players epecified in [p] of the grame on
   the background on the initial position and moves the players around*)

(* val draw_player: Player.t -> unit *)

(**[draw_bomb b] draws the bomb [b] placed by the player and the
   animation of bombing*)

(* val draw_bomb : State.t -> unit *)

val tile_size : int

val tile_number : int

val draw_canvas : unit -> unit

val draw_bkg : unit -> unit

val draw_board : unit -> unit

val draw_heart_3 : unit -> unit

val draw_minus_heart : Bomb.t list -> Player.t -> unit

val draw_head : unit -> unit

val draw_obs : Background.t -> unit

val init_p1_xy : string -> int * int

val draw_plr1 : int * int -> unit

(* val draw_plr2 : int * int -> unit *)

val draw_state : State.t -> unit

(* val move : State.t -> unit *)

(* val input : State.t -> unit *)

val draw_move : State.t -> int * int -> unit

val draw_bomb : int * int -> unit

val draw_tile : int -> int -> unit

val draw_tiles : (int * int) list -> unit

val draw_explosions : Bomb.t list -> Background.t -> Player.t -> unit

val draw_speedups : (int * int) list -> unit

val clear_speedup : State.t -> unit

val draw_burnt_pl : int * int -> unit

(* val draw_move : State.t -> int * int -> int * int -> unit *)
