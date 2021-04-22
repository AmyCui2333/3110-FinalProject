(** Representation of static background type.

    This module represents the data used to represent backgrounds. It
    loads json files that contain information about obstacles and tiles
    and stores them in a background object *)

(** The abstract type of values representing backgrounds. *)
type t

(** The type of obstacle ids. *)
type obs_id = int

(** The type of coordinates of obstacles/tiles *)
type xy = int * int

val tile_size : int

val tile_number : int

val move_number : int

(** [from_json j] is the background that [j] represents. Requires: [j]
    is a valid JSON background representation. *)
val from_json : Yojson.Basic.t -> t

(** [start_tile_one bkg] is the identifier of the starting tile of
    player one in background [bkg]. *)
val start_tile_one : t -> xy

(** [start_tile_two bkg] is the identifier of the starting tile of
    player two in background [bkg]. *)
val start_tile_two : t -> xy

(** [obs_ids a] is a set-like list of all of the obstacle identifiers in
    background [a]. *)
val obs_ids : t -> int list

(** [obs_one_xy a] is a set-like list of all of the type one obstacle
    identifiers in background [a]. *)
val obs_one_xy : t -> xy list

(** [obs_two_xy a] is a set-like list of all of the type two obstacle
    identifiers in background [a]. *)
val obs_two_xy : t -> xy list

(** [obs_on_x x] is a list of all obstacles on row x. *)
val obs_on_x : t -> int -> int list

(** [obs_on_y y] is a list of all obstacles on column y. *)
val obs_on_y : t -> int -> int list

val clear_obstacles : (int * int) list -> t -> t
