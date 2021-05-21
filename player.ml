open Background

type player_type = string

type xy = int * int

let tile_size = Background.tile_size

let tile_number = Background.tile_number

let move_number = Background.move_number

type t = {
  player_type : player_type;
  speed : int;
  curr_pos : xy;
  lives : int;
  bomb_power : int;
}

let curr_pos t = t.curr_pos

let get_power t = t.bomb_power

let build_player ply_type curr_pos =
  {
    player_type = ply_type;
    speed = move_number;
    curr_pos;
    lives = 3;
    bomb_power = 1;
  }

let get_speed p = p.speed

let get_plr_type p = p.player_type

let change_speed p s = { p with speed = s }

let get_bomb p = p.bomb_power

let change_bomb p b = { p with bomb_power = b }

let change_pl_pos plr pos = { plr with curr_pos = pos }

let lives p = p.lives

let kill p = { p with lives = p.lives - 1 }

let add p = if p.lives < 3 then { p with lives = p.lives + 1 } else p

let move_up p =
  { p with curr_pos = (fst (curr_pos p), snd (curr_pos p) + p.speed) }

let move_down p =
  { p with curr_pos = (fst (curr_pos p), snd (curr_pos p) - p.speed) }

let move_left p =
  { p with curr_pos = (fst (curr_pos p) - p.speed, snd (curr_pos p)) }

let move_right p =
  { p with curr_pos = (fst (curr_pos p) + p.speed, snd (curr_pos p)) }

let no_collisiony bkg p op move =
  if
    fst (curr_pos p)
    |> obs_on_x bkg
    |> List.mem (op (snd (curr_pos p)) tile_size)
    || fst (curr_pos p) mod tile_size <> 0
  then p
  else move p

let no_collisionx bkg p op move =
  if
    snd (curr_pos p)
    |> obs_on_y bkg
    |> List.mem (op (fst (curr_pos p)) tile_size)
    || snd (curr_pos p) mod tile_size <> 0
  then p
  else move p

let no_collision_up bkg p = no_collisiony bkg p ( + ) move_up

let no_collision_down bkg p = no_collisiony bkg p ( - ) move_down

let no_collision_left bkg p = no_collisionx bkg p ( - ) move_left

let no_collision_right bkg p = no_collisionx bkg p ( + ) move_right

let check_tool_collision f xy p = f xy == f (curr_pos p)

let tool_collision_right xy p =
  if check_tool_collision snd xy p then
    fst xy - fst (curr_pos p) = tile_size / 2
  else false

let tool_collision_left xy p =
  if check_tool_collision snd xy p then
    fst (curr_pos p) - fst xy = tile_size / 2
  else false

let tool_collision_up xy p =
  if check_tool_collision fst xy p then
    snd xy - snd (curr_pos p) = tile_size / 2
  else false

let tool_collision_down xy p =
  if check_tool_collision fst xy p then
    snd (curr_pos p) - snd xy = tile_size / 2
  else false

let rec tool_collision xy p =
  tool_collision_right xy p
  || tool_collision_left xy p
  || tool_collision_up xy p
  || tool_collision_down xy p

let tool_collision_right_return xy p num =
  if check_tool_collision snd xy p then
    (fst xy - fst (curr_pos p) = num, xy)
  else (false, (0, 0))

let tool_collision_left_return xy p num =
  if check_tool_collision snd xy p then
    (fst (curr_pos p) - fst xy = num, xy)
  else (false, (0, 0))

let tool_collision_up_return xy p num =
  if check_tool_collision fst xy p then
    (snd xy - snd (curr_pos p) = num, xy)
  else (false, (0, 0))

let tool_collision_down_return xy p num =
  if check_tool_collision fst xy p then
    (snd (curr_pos p) - snd xy = num, xy)
  else (false, (0, 0))

let tool_collison_return_aux xy p num =
  let cd = tool_collision_down_return xy p num in
  let cu = tool_collision_up_return xy p num in
  let ct = tool_collision_left_return xy p num in
  let cr = tool_collision_right_return xy p num in
  let c_all = [ cd; cu; ct; cr ] in
  List.filter (fun x -> fst x) c_all

let tool_collison_return xy p =
  tool_collison_return_aux xy p (tile_size / 2)

let tool_collison_gui_return xy p = tool_collison_return_aux xy p 30

let rec tools_collision_return_aux xy_lst p f =
  match xy_lst with
  | [] -> (false, (0, 0))
  | h :: t -> (
      match f h p with
      | [] -> tools_collision_return_aux t p f
      | [ h ] -> h
      | h :: t -> h)

let rec tools_collision_return xy_lst p =
  tools_collision_return_aux xy_lst p tool_collison_return

let rec tools_collision_gui_return xy_lst p =
  tools_collision_return_aux xy_lst p tool_collison_gui_return

let ( <+> ) (a : bool * (int * int)) b = if fst a = true then a else b

let rec tools_collision xy_lst p =
  match xy_lst with
  | [] -> false
  | h :: t -> tool_collision h p || tools_collision t p

let tool_collision_right_gui xy p =
  if check_tool_collision snd xy p then
    fst xy - fst (curr_pos p) = 30 || snd (curr_pos p) - snd xy = 20
  else false

let tool_collision_left_gui xy p =
  if check_tool_collision snd xy p then
    fst (curr_pos p) - fst xy = 30 || snd (curr_pos p) - snd xy = 20
  else false

let tool_collision_up_gui xy p =
  if check_tool_collision fst xy p then
    snd xy - snd (curr_pos p) = 30 || snd (curr_pos p) - snd xy = 20
  else false

let tool_collision_down_gui xy p =
  if check_tool_collision fst xy p then
    snd (curr_pos p) - snd xy = 30 || snd (curr_pos p) - snd xy = 20
  else false

let rec tool_collision_gui xy p =
  tool_collision_right_gui xy p
  || tool_collision_left_gui xy p
  || tool_collision_up_gui xy p
  || tool_collision_down_gui xy p
