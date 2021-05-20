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

let show_tool4 b bkg =
  let tool4_list = tool4_xy bkg in
  let grids = get_neighbours 1 b [] in
  List.filter (fun x -> List.mem x grids) tool4_list

let rec show_tool4s b_lst bkg =
  match b_lst with
  | [] -> []
  | h :: t -> show_tool4 h bkg @ show_tool4s t bkg
