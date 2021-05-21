(** Using library module "Graphic_image" to display Game GUI *)

val tile_size : int

val tile_number : int

val draw_canvas : unit -> unit

val draw_bkg : unit -> unit

val draw_board : unit -> unit

val draw_heart_3 : unit -> unit

val draw_heart_on_board : Player.t -> unit

val draw_head : unit -> unit

val draw_obs : Background.t -> unit

val init_p1_xy : string -> string -> int * int

val draw_plr1 : State.t -> int * int -> unit

val draw_state : State.t -> unit

val draw_move : State.t -> int * int -> (int * int) option -> unit

val draw_bomb : int * int -> unit

val draw_tile : int -> int -> unit

val draw_tiles : (int * int) list -> unit

val draw_explosions : Bomb.t list -> State.t -> Player.t -> unit

val draw_speedups : (int * int) list -> unit

val draw_addhearts : (int * int) list -> unit

val clear_tools : State.t -> unit

val draw_tools : State.t -> unit

val draw_burnt_pl : int * int -> unit

val draw_enemy : (int * int) option -> unit

val draw_score : State.t -> unit

val draw_win : State.t -> unit

val draw_lose : State.t -> unit

val draw_final_score : State.t -> unit

val draw_choose : unit -> unit

val draw_instruction : unit -> unit

val draw_left_panel : unit -> unit
