open Player
open Bomb
open Background

type t = { pos : int * int }

let get_addheart_xy t = t.pos

let show_tool2 b bkg =
  let tool2_list = tool2_xy bkg in
  let tiles = get_neighbours 1 b [] in
  List.filter (fun x -> List.mem x tiles) tool2_list

let rec show_tool2s b_lst bkg =
  match b_lst with
  | [] -> []
  | h :: t -> show_tool2 h bkg @ show_tool2s t bkg

let new_addheart xy = { pos = xy }

let rec new_addhearts_fromxy xy_lst =
  match xy_lst with
  | [] -> []
  | h :: t -> [ new_addheart h ] @ new_addhearts_fromxy t
