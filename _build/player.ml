open Background

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

let move_up p =
  { p with curr_pos = (fst (curr_pos p), snd (curr_pos p) + 20) }

let move_down p =
  { p with curr_pos = (fst (curr_pos p), snd (curr_pos p) - 20) }

let move_left p =
  { p with curr_pos = (fst (curr_pos p) - 20, snd (curr_pos p)) }

let move_right p =
  { p with curr_pos = (fst (curr_pos p) + 20, snd (curr_pos p)) }

let no_collisiony bkg p op move =
  if
    fst (curr_pos p)
    |> obs_on_x bkg
    |> List.mem (op (snd (curr_pos p)) 80)
    || fst (curr_pos p) mod 80 <> 0
  then p
  else move p

let no_collisionx bkg p op move =
  if
    snd (curr_pos p)
    |> obs_on_y bkg
    |> List.mem (op (fst (curr_pos p)) 80)
    || snd (curr_pos p) mod 80 <> 0
  then p
  else move p

let no_collision_up bkg p = no_collisiony bkg p ( + ) move_up

let no_collision_down bkg p = no_collisiony bkg p ( - ) move_down

let no_collision_left bkg p = no_collisionx bkg p ( - ) move_left

let no_collision_right bkg p = no_collisionx bkg p ( + ) move_right
