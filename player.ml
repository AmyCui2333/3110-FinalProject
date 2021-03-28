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

(* let move_up : t -> t

   let move_down : t -> t

   let move_left : t -> t

   let move_right : t -> t *)
