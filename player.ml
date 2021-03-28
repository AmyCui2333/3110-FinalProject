(* open Background *)

type player_id = string

type xy = int * int

type t = {
  id : player_id;
  speed : int;
  curr_pos : xy;
  lives : int;
}

let curr_pos t = t.curr_pos

let build_player id curr_pos = { id; speed = 20; curr_pos; lives = 3 }

let get_speed p = p.speed

let speed_up p s = { p with speed = p.speed + s }

let lives p = p.lives

let kill p = { p with lives = p.lives - 1 }

(* let no_collision_down p *)

let move_up p =
  { p with curr_pos = (fst (curr_pos p) + 20, snd (curr_pos p)) }

let move_down p =
  { p with curr_pos = (fst (curr_pos p) - 20, snd (curr_pos p)) }

let move_left p =
  { p with curr_pos = (fst (curr_pos p), snd (curr_pos p) - 20) }

let move_right p =
  { p with curr_pos = (fst (curr_pos p), snd (curr_pos p) + 20) }
