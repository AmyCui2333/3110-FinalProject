open Player
open Bomb
open Background

type t = { pos : int * int }

let get_twobomb_xy t = t.pos

let new_twobomb xy = { pos = xy }

let rec new_twobombs_fromxy xy_lst =
  match xy_lst with
  | [] -> []
  | h :: t -> [ new_twobomb h ] @ new_twobombs_fromxy t
