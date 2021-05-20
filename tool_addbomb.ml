open Player
open Bomb
open Background

type t = {
  pos : int * int;
  (* start_time : float; duration_time : float; *)
  range_factor : int;
}

let get_bomb_xy t = t.pos

let new_addbomb xy = { pos = xy; range_factor = 2 }

let bombup_plr p = change_bomb p (get_bomb p + 1)

let rec new_addbombs_fromxy xy_lst =
  match xy_lst with
  | [] -> []
  | h :: t -> [ new_addbomb h ] @ new_addbombs_fromxy t

let show_tool3 b bkg =
  let tool3_list = tool3_xy bkg in
  let grids = get_neighbours 1 b [] in
  List.filter (fun x -> List.mem x grids) tool3_list

let rec show_tool3s b_lst bkg =
  match b_lst with
  | [] -> []
  | h :: t -> show_tool3 h bkg @ show_tool3s t bkg
