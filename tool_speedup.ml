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

let show_tool1 b bkg =
  let tool1_list = tool1_xy bkg in
  let grids = get_neighbours b in
  List.filter (fun x -> List.mem x grids) tool1_list

let rec show_tool1s b_lst bkg =
  match b_lst with
  | [] -> []
  | h :: t -> show_tool1 h bkg @ show_tool1s t bkg

let new_speedup p xy =
  if
    fst (curr_pos p) mod tile_size = 0
    && snd (curr_pos p) mod tile_size = 0
  then
    Some
      {
        pos = xy;
        speed_factor = 2;
        start_time = Unix.time ();
        duration_time = 5.0;
      }
  else None

let new_speedup_return p xy =
  match new_speedup p xy with Some speedup -> [ speedup ] | None -> []

let rec new_speedups p b_lst bkg =
  let tool_xy_lst = show_tool1s b_lst bkg in
  match tool_xy_lst with
  | [] -> []
  | h :: t -> new_speedup_return p h @ new_speedups p b_lst bkg

let speedup t p = change_speed p (get_speed p * 2)

let check_end t =
  if Unix.time () -. t.start_time >= t.duration_time then true
  else false

let speedback p = change_speed p (get_speed p / 2)

let show bkg b = get_neighbours b
