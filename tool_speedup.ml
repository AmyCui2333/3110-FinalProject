open Player
open Bomb
open Background

type t = {
  pos : int * int;
  start_time : float;
  duration_time : float;
  speed_factor : int;
}

let get_speedup_xy t = t.pos

let new_speedup xy =
  {
    pos = xy;
    speed_factor = 2;
    start_time = Unix.time ();
    duration_time = 5.0;
  }

let rec new_speedups_fromxy xy_lst =
  match xy_lst with
  | [] -> []
  | h :: t -> [ new_speedup h ] @ new_speedups_fromxy t

let xy_to_speedup xy speedup_lst =
  List.hd (List.filter (fun x -> xy = x.pos) speedup_lst)

let speedup_plr t p = change_speed p (get_speed p * t.speed_factor)
