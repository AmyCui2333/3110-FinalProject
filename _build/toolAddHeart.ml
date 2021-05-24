open Player
open Bomb
open Background

type t = { pos : int * int }

let get_addheart_xy t = t.pos

let new_addheart xy = { pos = xy }

let rec new_addhearts_fromxy xy_lst =
  match xy_lst with
  | [] -> []
  | h :: t -> [ new_addheart h ] @ new_addhearts_fromxy t
