(** Representation of static background type.

    This module represents the data used to represent backgrounds. It
    loads json files that contain information about obstacles and tiles
    and stores them in a background. *)

(** The abstract type of values representing backgrounds. *)
type t

(** The type of coordinates of tiles *)
type xy = int * int

(** The size of one piece of tile in our map. This is the size of all
    tools, obstacles, bombs, player, and enemies. *)
val tile_size : int

(** The numer of tiles in one row/column of our square map. *)
val tile_number : int

(** The numer of pixels the player can move across with one movement. *)
val move_number : int

(** [from_json j] is the background that [j] represents. Requires: [j]
    is a valid JSON background representation. *)
val from_json : Yojson.Basic.t -> t

(** [start_tile_one bkg] is the identifier of the starting tile of
    player one in background [bkg]. *)
val start_tile_one : t -> xy

(** [obs_one_xy bkg] is a list of all of the type one obstacle
    coordinates in background [bkg]. *)
val obs_one_xy : t -> xy list

(** [obs_two_xy bkg] is a list of all of the type two obstacle
    coordinates in background [bkg]. *)
val obs_two_xy : t -> xy list

(** [obs_three_xy bkg] is a list of all of the type two obstacle
    (portal) identifiers in background [bkg]. *)
val obs_three_xy : t -> xy list

(** [obs_on_x bkg x] is a list of all obstacles on row [x] in background
    map [bkg]. *)
val obs_on_x : t -> int -> int list

(** [obs_on_y bkg y] is a list of all obstacles on column [y] in
    background map [bkg]. *)
val obs_on_y : t -> int -> int list

(** [clear_obstacles xy bkg] returns an updated background [bkg] where
    obstacles located in positions [xy] are cleared by bombs. *)
val clear_obstacles : xy list -> t -> t

(** [tool_xy bkg i] returns a list of tool_[i] in background map [bkg]. *)
val tool_xy : t -> int -> xy list

(** [all_tools bkg] returns a list of all tools' positions in background
    map [bkg]. *)
val all_tools : t -> xy list
