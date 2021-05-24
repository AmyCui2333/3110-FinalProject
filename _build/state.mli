(** Representation of dynamic game state.

    This module represents the state of a game as it is being played,
    including all information about game map (i.e., background), the
    player, bomb, tools, enemy, score, and functions that cause the
    state to change. *)

(** The abstract type of values representing the game state. *)
type t

(** The type representing the result of an attempted command. Legal:
    allowed movement (up, down, left, right). Make_bomb: putting a bomb
    at the current position. Exit: end and exit the game. *)
type input =
  | Legal of t
  | Make_bomb of t
  | Exit

(** [init_state bkg pos plr_type] initiates a state with player at
    [pos], background [bkg], and player type of [plr_type] *)
val init_state : Background.t -> Player.xy -> string -> t

(** [get_bkg st] returns the background the player is playing in. *)
val get_bkg : t -> Background.t

(** [player_one t] returns the player_one object. *)
val player_one : t -> Player.t

(** [get_tool1 st] returns a list of tools of type 1 "Speed-Up". *)
val get_tool1 : t -> ToolSpeedUp.t list

(** [get_tool2 st] returns a list of tools of type 2 "Add-Heart". *)
val get_tool2 : t -> ToolAddHeart.t list

(** [get_tool3 st] returns a list of tools of type 3 "Add-Bomb-Power". *)
val get_tool3 : t -> ToolAddBomb.t list

(** [get_tool4 st] returns a list of tools of type 4 "Two-Bombs". *)
val get_tool4 : t -> ToolTwoBomb.t list

(** [take_input st] takes in the input from the keyboard. *)
val take_input : t -> input

(** [take_mouse] takes in the input from the mouse and returns either
    "camel" or "lama" according to the player's choice. *)
val take_mouse : unit -> string

(** [take_start] stops displaying the instruction page after taking in
    any input from the player's mouse. *)
val take_start : unit -> unit

(** [take_map] takes in the input from the mouse and returns a string
    that is "easy.json", "normal.json", or "hard.json", according to
    the player's choice. The returned string represents the background
    json file that the game engine will load. *)
val take_map : unit -> string

(** [add_bomb b st] adds one bomb into the st. *)
val add_bomb : Bomb.t -> t -> t

(** [some explosion st] returns true if at lease one bomb is about to
   explode, false otherwise. *)
val some_explosion : t -> bool

(** [clear_explode st] updates the [st] with the new background after
    explosion (if any) and the bombs left. *)
val clear_exploding : t -> t

(** [exploding st] returns a list of bombs to be exploded at the time
    the function is called. *)
val exploding : t -> Bomb.t list

(** [get_tool1_xys st] returns a list of positions of tool_1 "Speed-Up". *)
val get_tool1_xys : t -> (int * int) list

(** [get_tool2_xys st] returns a list of positions of tool_2
    "Add-Heart". *)
val get_tool2_xys : t -> (int * int) list

(** [get_tool3_xys st] returns a list of positions of tool_3
    "Add-Bomb-Power". *)
val get_tool3_xys : t -> (int * int) list

(** [get_tool4_xys st] returns a list of positions of tool_4
    "Two-Bombs". *)
val get_tool4_xys : t -> (int * int) list

(** [check_dead st] returns true if the player's remaining number of
    lives becomes 0; false is the player has more than 3 hearts. *)
val check_dead : t -> bool

(** [speedback_plr p st] changes the speed of player [p] back to original
   in state [st]. *)
val speedback_plr : Player.t -> t -> t

(** [get_enemy_pos st] returns Some postion if there is an enemy in [st],
   None if there isn't. *)
val get_enemy_pos : t -> (int * int) option

(** [get_score st] gets current score from the state [st]. *)
val get_score : t -> int

(** [check_dead st] returns true if the player's remaining number of
    lives becomes 0; false is the player has more than 3 hearts. *)
val get_portal_pos : t -> (int * int) list

(** [all_cleared st] returns true if there are no more tools or obstacles
   or enemies in [st], false otherwise. *)
val all_cleared : t -> bool
