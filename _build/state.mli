(** Representation of dynamic game state.

    This module represents the state of a game as it is being played,
    including all information about game map (i.e., background), the
    player, bomb, tools, enemy, score, and functions that cause the
    state to change. *)

(** The abstract type of values representing the game state. *)
type t

(** The type representing the result of an attempted command. Legal:
    allowed movement (up, down, left, right). Make_bomb: putting a bomb
    at the current position. Exit: end and exit the game. *)
type input =
  | Legal of t
  | Make_bomb of t
  | Exit

(** [init_state bkg pos plr_type] initiates a state with player at
    [pos], background [bkg], and player type of [plr_type] *)
val init_state : Background.t -> Player.xy -> string -> t

(** [get_bkg st] returns the background the player is playing in. *)
val get_bkg : t -> Background.t

(** [player_one t] returns the player_one object. *)
val player_one : t -> Player.t

(** [get_tool1 st] returns a list of tools of type 1 "speed-up". *)
val get_tool1 : t -> Tool_speedup.t list

(** [get_tool2 st] returns a list of tools of type 2 "add heart". *)
val get_tool2 : t -> Tool_addheart.t list

(** [get_tool3 st] returns a list of tools of type 3 "bomb power-up". *)
val get_tool3 : t -> Tool_addbomb.t list

(** [get_tool4 st] returns a list of tools of type 4 "double bombs". *)
val get_tool4 : t -> Tool_twobomb.t list

(** [take_input st] takes in the input from the keyboard. *)
val take_input : t -> input

val take_mouse : unit -> string

val take_start : unit -> unit

(** [change_bkg st b] returns the state with bkg [b]. *)
val change_bkg : t -> Background.t -> t

(** [add_bomb b st] adds one bomb into the st. *)
val add_bomb : Bomb.t -> t -> t

(**[some explosion st] returns true if at lease one bomb is about to
   explode, false otherwise*)
val some_explosion : t -> bool

(** [clear_explode st] updates the [st] with the new background after
    explosion (if any) and the bombs left. *)
val clear_exploding : t -> t

(** [exploding st] returns the bombs to be exploded at the time the
    function is called. *)
val exploding : t -> Bomb.t list

(** [take_tool1 st] returns the new state if player takes in any tool1s
    and change the state and the tool1 list of the state. *)
val take_tool1 : t -> t

val get_tool1_xys : t -> (int * int) list

val get_tool2_xys : t -> (int * int) list

val get_tool3_xys : t -> (int * int) list

val get_tool4_xys : t -> (int * int) list

(** [check_dead st] returns true if the player's remaining number of
    lives becomes 0; false is the player has more than 3 hearts. *)
val check_dead : t -> bool

(**[speedback_plr p st] changes the speed of player [p] back to original
   in state [st]. *)
val speedback_plr : Player.t -> t -> t

(**[get_enemy_pos st] returns Some postion if there is an enemy in [st],
   None if there isn't. *)
val get_enemy_pos : t -> (int * int) option

(**[get_score st] gets current score from the state [st]. *)
val get_score : t -> int

(** [check_dead st] returns true if the player's remaining number of
    lives becomes 0; false is the player has more than 3 hearts. *)
val get_portal_pos : t -> (int * int) list

(**[all_cleared st] returns true if there are no more tools or obstacles
   or enemies in [st], false otherwise. *)
val all_cleared : t -> bool
