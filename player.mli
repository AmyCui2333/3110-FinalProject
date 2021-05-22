(** Representation of static background type.

    This module represents the data used to represent players. *)

(** The abstract type of values representing the player. *)
type t

(** The type of player ids. *)
type player_type = string

(** The type of coordinates of player *)
type xy = int * int

(** [build_player ply_type curr_pos] initializes a player according to
    the player's type [ply_type] and position [curr_pos]. *)
val build_player : player_type -> xy -> t

(** [get_plr_type plr] returns the player's type as either lama or camel *)
val get_plr_type : t -> player_type

(** [start_tile] is the identifier of the starting tile in the game. *)
val curr_pos : t -> xy

(** [get_speed p] gets the current speed of player p. *)
val get_speed : t -> int

(** [get_power p] returns the player [p]'s bomb power (explosion range). *)
val get_power : t -> int

(** [change_bomb p b] returns an updated player [p] whose bomb power is
    [b]. *)
val change_bomb : t -> int -> t

(** [change_speed p s] returns an updated player [p] whose speed of
    movement is [s]. *)
val change_speed : t -> int -> t

(** [change_pl_pos plr pos] returns an updated player [plr] whose
    position is [pos]. *)
val change_pl_pos : t -> xy -> t

(** [lives p] gets the current remaining lives (hearts) of player [p]. *)
val lives : t -> int

(** [kill p] decreases the remaining lives (hearts) of player [p] by 1
    and returns the new player. *)
val kill : t -> t

(** [add p] increases the lives of player [p] by 1 if the player has
    less than 3 hearts, and returns the updated player. *)
val add : t -> t

(** [no_collision_up bkg p] moves the player [p] up by one unit if there
    is nothing blocking the player in the background [bkg], and returns
    the updated player. *)
val no_collision_up : Background.t -> t -> t

(** [no_collision_down bkg p] moves the player [p] down by one unit if
    there is nothing blocking the player in the background [bkg], and
    returns the updated player. *)
val no_collision_down : Background.t -> t -> t

(** [no_collision_left bkg p] moves the player [p] left by one unit if
    there is nothing blocking the player in the background [bkg], and
    returns the updated player. *)
val no_collision_left : Background.t -> t -> t

(** [no_collision_right bkg p] moves the player [p] right by one unit if
    there is nothing blocking the player in the background [bkg], and
    returns the updated player. *)
val no_collision_right : Background.t -> t -> t

(** [tools_collision_return xy_list player] returns (true, the postion
    of the tool) if there is collison of the palyer and the tools at
    posions in xy_list, else reture (false, the postion of last instance
    of tool collison). The collision is true when the player ocupies the
    half of the grid of the tool's position *)
val tools_collision_return : xy list -> t -> bool * xy

(** [tools_collision_gui_return xy_list player]returns (true, the
    postion of the tool) if there is collison of the palyer and the
    tools at posions in xy_list, else reture (false, the postion of last
    instance of tool collison). The collision is true when the player
    ocupies any of the grid of the tool's position *)
val tools_collision_gui_return : xy list -> t -> bool * xy

(** [(bool1, xy1) <+> (bool2, xy2)] returns (true, xy1) if bool1 is
    true, else (bool2, xy2). *)
val ( <+> ) : bool * xy -> bool * xy -> bool * xy
