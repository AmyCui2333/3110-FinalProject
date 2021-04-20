open Player
open Background
open State

type t = {
  pos : int * int;
  power : int;
}

let make_bomb p = { pos = curr_pos p; power = get_power p }

let get_neighbours b =
  let x, y = b.pos in
  [
    (x + (b.power * 80), y);
    (x - (b.power * 80), y);
    (x, y + (b.power * 80));
    (x, y - (b.power * 80));
  ]

let explode st b =
  let surr = get_neighbours b in
  let new_bkg = clear_obstacles surr (get_bkg st) in
  change_bkg st new_bkg
