(** Representation of static background type.

    This module represents the data used to represent backgrounds. It
    loads json files that contain information about obstacles and tiles
    and stores them in a background object *)

(** The abstract type of values representing backgrounds. *)
type t

(** The type of obstacle ids. *)
type obs_id = string

(** The type of coordinates of obstacles/tiles *)
type xy = int * int

(** [from_json j] is the background that [j] represents. Requires: [j]
    is a valid JSON background representation. *)
val from_json : Yojson.Basic.t -> t

(** [start_tile a] is the identifier of the starting tile in adventure
    [a]. *)
val start_tile : t -> xy

(** [obs_ids a] is a set-like list of all of the obstacle identifiers in
    background [a]. *)
val obs_ids : t -> obs_id list

(** [obs_one_xy a] is a set-like list of all of the type one obstacle
    identifiers in background [a]. *)
val obs_one_xy : t -> xy list

(** [obs_two_xy a] is a set-like list of all of the type two obstacle
    identifiers in background [a]. *)
val obs_two_xy : t -> xy list
