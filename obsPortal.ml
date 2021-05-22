open Player
open Bomb
open Background

type t = {
  pos : int * int;
  pos2 : int * int;
}

let get_portal_lower_xy t = t.pos

let get_portal_upper_xy t = t.pos2

let new_portal bkg =
  {
    pos = List.hd (obs_three_xy bkg);
    pos2 = List.hd (List.rev (obs_three_xy bkg));
  }

let portal_pos xy t =
  match xy with
  | a, b when (a, b) = t.pos -> (a, b - 40)
  | a, b when (a, b) = t.pos2 -> (a, b + 40)
  | _ -> failwith "impossible"

let transfer_pl p new_pos = change_pl_pos p new_pos
