open Background

type player_id = string

type xy = int * int

let tile_size = 40

let tile_number = 16

let move_number = 10

type t = {
  id : player_id;
  speed : int;
  curr_pos : xy;
  lives : int;
  bomb_power : int;
}

let curr_pos t = t.curr_pos

let get_power t = t.bomb_power

let build_player id curr_pos =
  { id; speed = move_number; curr_pos; lives = 3; bomb_power = 1 }

let get_speed p = p.speed

(* let speed_up p s = { p with speed = p.speed + s } *)

let change_speed p s = { p with speed = s }

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

(* let no_collison_plry (op : int -> int -> int) (p1 : int * int) p2 =
   if fst p1 = fst p2 then op (snd p1) tile_size = snd p2 else false

   let no_collison_plrx op p1 p2 = if snd p1 = snd p2 then op (fst p1)
   tile_size = fst p2 else false *)

(* let no_collisiony bkg p p2 op move = if fst (curr_pos p) |> obs_on_x
   bkg |> List.mem (op (snd (curr_pos p)) tile_size) || fst (curr_pos p)
   mod tile_size <> 0 || no_collison_plry op (curr_pos p) (curr_pos p2)
   then p else move p *)

let no_collisiony bkg p op move =
  if
    fst (curr_pos p)
    |> obs_on_x bkg
    |> List.mem (op (snd (curr_pos p)) tile_size)
    || fst (curr_pos p) mod tile_size <> 0
  then p
  else move p

(* let no_collisionx bkg p p2 op move = if snd (curr_pos p) |> obs_on_y
   bkg |> List.mem (op (fst (curr_pos p)) tile_size) || snd (curr_pos p)
   mod tile_size <> 0 || no_collison_plrx op (curr_pos p) (curr_pos p2)
   then p else move p *)

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
  (* print_endline "e"; *)
  (* print_endline (string_of_bool (tool_collision xy p)); *)
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

(* let tool_collision *)

(* let rec tools_collision_return xy_lst p = match xy_lst with | [] ->
   (* failwith "imp" *) (false, (0, 0)) | h :: t -> ( match
   tool_collison_return h p with | [] -> tools_collision_return t p | [
   h ] -> h | h :: t -> h) *)

let rec tools_collision_return_aux xy_lst p f =
  match xy_lst with
  | [] ->
      (* failwith "imp" *)
      (false, (0, 0))
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
  (* print_endline "e"; *)
  (* print_endline (string_of_bool (tool_collision xy p)); *)
  tool_collision_right_gui xy p
  || tool_collision_left_gui xy p
  || tool_collision_up_gui xy p
  || tool_collision_down_gui xy p

(* let no_collision_up bkg p p2 = no_collisiony bkg p p2 ( + ) move_up

   let no_collision_down bkg p p2 = no_collisiony bkg p p2 ( - )
   move_down

   let no_collision_left bkg p p2 = no_collisionx bkg p p2 ( - )
   move_left

   let no_collision_right bkg p p2 = no_collisionx bkg p p2 ( + )
   move_right *)
