(** Using library module "Graphic_image" to display Game GUI *)

(** [draw_canvas ()] initializes the window for this game *)
val draw_canvas : unit -> unit

(** [draw_heart_on_board plr] draws hearts on the left panel based on
    how many lives [plr] has left *)
val draw_heart_on_board : Player.t -> unit

(** [draw_state st] draws the player, enemy, and obstacles of a state
    [st] *)
val draw_state : State.t -> unit

(** [draw_move st plr_pos enemy_pos] covers up the grids at [plr_pos]
    and [enemy_pos], which are the player and enemy's previous position.
    It then draws the new player and enemy according to [st] *)
val draw_move : State.t -> int * int -> (int * int) option -> unit

(** [draw_bomb bomb_pos] draws a bomb at the position [bomb_pos] *)
val draw_bomb : int * int -> unit

(** [draw_explosions] draws the animation of bomb explosion*)
val draw_explosions : Bomb.t list -> State.t -> Player.t -> unit

(** erase the tools taken in by the player*)
val clear_tools : State.t -> unit

(** draw all tools bombed out from bombs if any *)
val draw_tools : State.t -> unit

(** [draw_score st] covers up the previous score on the left panel and
    draws the current score stored in state [st] *)
val draw_score : State.t -> unit

(** [draw_win st] draw the win screen with win message and score. Exit
    the game 7 seconds after this screen. *)
val draw_win : State.t -> unit

(** [draw_lose st] draw the lose screen with win message and score. Exit
    the game 7 seconds after this screen. *)
val draw_lose : State.t -> unit

(** [draw_chooose ()] draw the choose player screen and allow users to
    pick charater Lama or Camel *)
val draw_choose : unit -> unit

(** [draw_instruction ()] draw the instruction page as the start of the
    game *)
val draw_instruction : unit -> unit

(** [draw_left_panel st ] draw the initial left panel showing the
    character headshot, initial hearts, and intila score 0*)
val draw_left_panel : State.t -> unit
