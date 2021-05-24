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

let rec get_neighbours power b lst =
  if power = b.power + 1 then lst
  else
    let x, y = b.pos in
    let new_lst =
      List.concat
        [
          [
            (x + (power * tile_size), y);
            (x - (power * tile_size), y);
            (x, y + (power * tile_size));
            (x, y - (power * tile_size));
          ];
          lst;
        ]
    in
    get_neighbours (power + 1) b new_lst

let in_cross cen left right top bottom x y =
  right > x && x > left
  && y < snd cen + tile_size
  && y > snd cen - tile_size
  || top > y && bottom < y
     && x < fst cen + tile_size
     && x > fst cen - tile_size

let in_blast_area b pos =
  let x, y = b.pos in
  let left = x - ((b.power + 1) * tile_size) in
  let right = x + ((b.power + 1) * tile_size) in
  let top = y + ((b.power + 1) * tile_size) in
  let bottom = y - ((b.power + 1) * tile_size) in
  let p1_x, p1_y = (fst pos, snd pos) in
  in_cross (x, y) left right top bottom p1_x p1_y

let in_blast_lst b_lst pl =
  let blasts = List.filter (fun x -> in_blast_area x pl) b_lst in
  if blasts = [] then false else true

let check_explode b =
  if Unix.time () -. b.start_time >= 5.0 then true else false

let rec explode bkg b_lst =
  match b_lst with
  | [] -> bkg
  | b :: t ->
      let surr = get_neighbours 1 b [] in
      let new_bkg = clear_obstacles surr bkg in
      explode new_bkg t

let get_pos b = b.pos

let show_tool b bkg i =
  let tool_list = tool_xy bkg i in
  let tiles = get_neighbours 1 b [] in
  List.filter (fun x -> List.mem x tiles) tool_list

let rec show_tools b_lst bkg i =
  match b_lst with
  | [] -> []
  | h :: t -> show_tool h bkg i @ show_tools t bkg i
