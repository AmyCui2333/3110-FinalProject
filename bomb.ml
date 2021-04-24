open Player
open Background

type t = {
  pos : int * int;
  power : int;
  start_time : float;
}

let make_bomb p =
  if
    fst (curr_pos p) mod tile_size = 0
    && snd (curr_pos p) mod tile_size = 0
  then
    Some
      {
        pos = curr_pos p;
        power = get_power p;
        start_time = Unix.time ();
      }
  else None

let get_neighbours b =
  let x, y = b.pos in
  [
    (x + (b.power * tile_size), y);
    (x - (b.power * tile_size), y);
    (x, y + (b.power * tile_size));
    (x, y - (b.power * tile_size));
  ]

let check_explode b =
  if Unix.time () -. b.start_time >= 3.0 then true else false

let rec explode bkg b_lst =
  match b_lst with
  | [] -> bkg
  | b :: t ->
      let surr = get_neighbours b in
      let new_bkg = clear_obstacles surr bkg in
      explode new_bkg t

let get_pos b = b.pos
