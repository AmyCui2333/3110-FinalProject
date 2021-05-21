(** Representation of static background type.

    This module represents the data used to represent backgrounds. It
    loads json files that contain information about obstacles and tiles
    and stores them in a background. *)

(** The abstract type of values representing backgrounds. *)
type t

(** The type of coordinates of tiles *)
type xy = int * int

(** The size of one tile from our map. *)
val tile_size : int

val tile_number : int

val move_number : int

(** [from_json j] is the background that [j] represents. Requires: [j]
    is a valid JSON background representation. *)
val from_json : Yojson.Basic.t -> t

(** [start_tile_one bkg] is the identifier of the starting tile of
    player one in background [bkg]. *)
val start_tile_one : t -> xy

(** [obs_one_xy a] is a list of all of the type one obstacle coordinates
    in background [a]. *)
val obs_one_xy : t -> xy list

(** [obs_two_xy a] is a list of all of the type two obstacle coordinates
    in background [a]. *)
val obs_two_xy : t -> xy list

(** [obs_three_xy a] is a list of all of the type two obstacle (portal)
    identifiers in background [a]. *)
val obs_three_xy : t -> xy list

(** [obs_on_x x] is a list of all obstacles on row x. *)
val obs_on_x : t -> int -> int list

(** [obs_on_y y] is a list of all obstacles on column y. *)
val obs_on_y : t -> int -> int list

(** [clear_obstacles y] is a list of all obstacles on column y. *)
val clear_obstacles : (int * int) list -> t -> t

val obs_xy_tool1 : t -> ((int * int) * int) list

val tool_xy : t -> int -> (int * int) list

val tool1_xy : t -> xy list

val obs_xy_tool2 : t -> ((int * int) * int) list

val tool2_xy : t -> xy list

val obs_xy_tool3 : t -> ((int * int) * int) list

val tool3_xy : t -> xy list

val obs_xy_tool4 : t -> ((int * int) * int) list

val tool4_xy : t -> xy list

val all_tools : t -> xy list
