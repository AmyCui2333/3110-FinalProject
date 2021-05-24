(** Representation of obstacles of type 3 "Portal Gateways." *)

(** The abstract type of values representing the portal gateways. *)
type t

(** [new_portal bkg] loads the background file [bkg] and initializes a
    portal object with two portal gateways according to the background
    file. *)
val new_portal : Background.t -> t

(** [get_portal_lower_xy port] returns the lower portal [port]'s
    position. *)
val get_portal_lower_xy : t -> int * int

(** [get_portal_upper_xy port] returns the upper portal [port]'s
    position. *)
val get_portal_upper_xy : t -> int * int

(** [portal_pos port pos] returns the adjusted position that the player
    will be transfered to, according to the position [pos] of portal
    gateway [port] that the player will be transfered to. *)
val portal_pos : t -> int * int -> int * int

(** [transfer_pl p pos] returns player [p] with an updated position
    [pos]. *)
val transfer_pl : Player.t -> int * int -> Player.t
