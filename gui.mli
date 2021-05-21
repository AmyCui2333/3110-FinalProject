(** Using library module "Graphic_image" to display Game GUI *)

(** TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO *)
val draw_canvas : unit -> unit

(** TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO *)
val draw_heart_on_board : Player.t -> unit

(** TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO *)
val draw_state : State.t -> unit

(** TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO *)
val draw_move : State.t -> int * int -> (int * int) option -> unit

(** TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO *)
val draw_bomb : int * int -> unit

(** draw the animation of bomb explosion*)
val draw_explosions : Bomb.t list -> State.t -> Player.t -> unit

(** erase the tools taken in by the player*)
val clear_tools : State.t -> unit

(** draw all tools bombed out from bombs if any *)
val draw_tools : State.t -> unit

(** TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO *)
val draw_score : State.t -> unit

(** TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO *)
val draw_win : State.t -> unit

(** TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO *)
val draw_lose : State.t -> unit

(** TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO *)
val draw_choose : unit -> unit

(** TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO *)
val draw_instruction : unit -> unit

(** TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO *)
val draw_left_panel : State.t -> unit
