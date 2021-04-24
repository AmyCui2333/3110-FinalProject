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

let in_cross cen left right top bottom x y =
  right > x && x > left
  && y < snd cen + tile_size
  && y > snd cen - tile_size
  || top > y && bottom < y
     && x < fst cen + tile_size
     && x > fst cen - tile_size

let in_blast_area b pl =
  let x, y = b.pos in
  let left = x - ((b.power + 1) * tile_size) in
  let right = x + ((b.power + 1) * tile_size) in
  let top = y + ((b.power + 1) * tile_size) in
  let bottom = y - ((b.power + 1) * tile_size) in
  let p1_x, p1_y = curr_pos pl in
  in_cross (x, y) left right top bottom p1_x p1_y

let in_blast_lst b_lst pl =
  let _ = print_endline "blast_lst called" in
  let blasts = List.filter (fun x -> in_blast_area x pl) b_lst in
  if blasts = [] then false
  else
    let _ = print_endline "in blast area" in
    true

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
