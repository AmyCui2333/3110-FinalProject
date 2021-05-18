open Player
open Bomb
open Background

(* type t = Tool of t *)

type t = {
  pos : int * int;
  start_time : float;
  duration_time : float;
  speed_factor : int;
}

let get_speedup_xy t = t.pos

let xy_to_speedup xy speedup_lst =
  List.hd (List.filter (fun x -> xy = x.pos) speedup_lst)

let show_tool1 b bkg =
  let tool1_list = tool1_xy bkg in
  let grids = get_neighbours 1 b [] in
  List.filter (fun x -> List.mem x grids) tool1_list

let rec show_tool1s b_lst bkg =
  match b_lst with
  | [] -> []
  | h :: t -> show_tool1 h bkg @ show_tool1s t bkg

let new_speedup xy =
  {
    pos = xy;
    speed_factor = 2;
    start_time = Unix.time ();
    duration_time = 5.0;
  }

(* let new_speedup_return p xy = match new_speedup xy with Some speedup
   -> [ speedup ] | None -> [] *)

let rec new_speedups b_lst bkg =
  let tool_xy_lst = show_tool1s b_lst bkg in
  match tool_xy_lst with [] -> [] | h :: t -> [ new_speedup h ]

let rec new_speedups_fromxy xy_lst =
  match xy_lst with
  | [] -> []
  | h :: t -> [ new_speedup h ] @ new_speedups_fromxy t

(*TODO: if mod40 : manully move ch*)
let speedup_plr t p = change_speed p (get_speed p * t.speed_factor)

let check_end t =
  if Unix.time () -. t.start_time >= t.duration_time then true
  else false

let speedback_plr t p =
  if check_end t then change_speed p (get_speed p / 2) else p

let show bkg b = get_neighbours b
