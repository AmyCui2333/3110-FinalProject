open Player
open Bomb
open Background

type t = {
  pos : int * int;
  pos2 : int * int;
}

let get_portal_xy t = t.pos

let new_portal xy = { pos = xy; pos2 = (1, 2) }

let transfer_pl p = change_bomb p (get_bomb p * 2)

let rec new_addbombs_fromxy xy_lst =
  match xy_lst with
  | [] -> []
  | h :: t -> [ new_portal h ] @ new_addbombs_fromxy t

let show_tool3 b bkg =
  let tool3_list = tool3_xy bkg in
  let grids = get_neighbours 1 b [] in
  List.filter (fun x -> List.mem x grids) tool3_list

let rec show_tool3s b_lst bkg =
  match b_lst with
  | [] -> []
  | h :: t -> show_tool3 h bkg @ show_tool3s t bkg
