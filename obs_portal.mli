(** Representation of obstacles of type 3 "Portal Gateways." *)

(** The abstract type of values representing the portal gateways. *)
type t

(** [get_portal1_xy port] returns the first portal [port]'s position. *)
val get_portal1_xy : t -> int * int

(** [get_portal2_xy port] returns the second portal [port]'s position. *)
val get_portal2_xy : t -> int * int

(** [new_portal bkg] loads the background file [bkg] and initializes a
    portal object with two portal gateways according to the background
    file. *)
val new_portal : Background.t -> t

(** [transfer_pl p pos] returns player [p] with an updated position
    [pos]. *)
val transfer_pl : Player.t -> int * int -> Player.t

(** [portal_pos pos port] returns the adjusted position that the player
    will be transfered to, according to the position [pos] of portal
    gateway [port] that the player will be transfered to. *)
val portal_pos : int * int -> t -> int * int
