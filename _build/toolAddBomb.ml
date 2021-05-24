open Player
open Bomb
open Background

type t = {
  pos : int * int;
  range_factor : int;
}

let get_bomb_xy t = t.pos

let new_addbomb xy = { pos = xy; range_factor = 2 }

let rec new_addbombs_fromxy xy_lst =
  match xy_lst with
  | [] -> []
  | h :: t -> [ new_addbomb h ] @ new_addbombs_fromxy t

let bombup_plr p = change_bomb p (get_power p + 1)
