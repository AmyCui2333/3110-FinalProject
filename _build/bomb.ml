open Player
open Background

type t = {
  pos : int * int;
  power : int;
  start_time : float;
}

let make_bomb p =
  { pos = curr_pos p; power = get_power p; start_time = Unix.time () }

let get_neighbours b =
  let x, y = b.pos in
  [
    (x + (b.power * 40), y);
    (x - (b.power * 40), y);
    (x, y + (b.power * 40));
    (x, y - (b.power * 40));
  ]

let check_explode b =
  if Unix.time () -. b.start_time >= 5.0 then true else false

let rec explode bkg b_lst =
  match b_lst with
  | [] -> bkg
  | b :: t ->
      let surr = get_neighbours b in
      let new_bkg = clear_obstacles surr bkg in
      explode new_bkg t

let get_pos b = b.pos
