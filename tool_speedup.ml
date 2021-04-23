open Player
open Bomb
open Background

type t = {
  pos : int * int;
  start_time : float;
  duration_time : float;
  speed_factor : int;
}

let new_speedup p =
  if
    fst (curr_pos p) mod tile_size = 0
    && snd (curr_pos p) mod tile_size = 0
  then
    Some
      {
        pos = curr_pos p;
        speed_factor = 2;
        start_time = Unix.time ();
        duration_time = 5.0;
      }
  else None

let speedup t p = change_speed p (get_speed p * 2)

let check_end t =
  if Unix.time () -. t.start_time >= t.duration_time then true
  else false

let speedback p = change_speed p (get_speed p / 2)

let show bkg t = check_tool
