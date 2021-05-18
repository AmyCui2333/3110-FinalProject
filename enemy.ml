open Background
open Player

type direction =
  | LEFT
  | RIGHT
  | UP
  | DOWN

let slow_speed = 20

let fast_speed = 40

type t = {
  speed : int;
  pos : int * int;
  off_tiles : (int * int) list;
}

let enemy_pos e = e.pos

let enemy_speed e = e.speed

let build_enemy pos off_tiles t =
  if t = "fast" then { speed = 20; pos; off_tiles }
  else { speed = 10; pos; off_tiles }

let move_enemy_up e = { e with pos = (fst e.pos, snd e.pos + e.speed) }

let move_enemy_down e =
  { e with pos = (fst e.pos, snd e.pos - e.speed) }

let move_enemy_left e =
  { e with pos = (fst e.pos - e.speed, snd e.pos) }

let move_enemy_right e =
  { e with pos = (fst e.pos + e.speed, snd e.pos) }

let obs_tools_on_x e bkg x =
  let obs = obs_on_x bkg x in
  let tools = List.filter (fun tile -> snd tile = x) e.off_tiles in
  let tools_y = List.map snd tools in
  obs @ tools_y

let obs_tools_on_y e bkg y =
  let obs = obs_on_y bkg y in
  let tools = List.filter (fun tile -> fst tile = y) e.off_tiles in
  let tools_x = List.map fst tools in
  obs @ tools_x

let enemy_no_collisiony bkg e op =
  let x = fst e.pos in
  obs_tools_on_x e bkg x |> List.mem (op (snd e.pos) tile_size)
  || fst e.pos mod tile_size <> 0

let enemy_no_collisionx bkg e op =
  let y = snd e.pos in
  obs_tools_on_y e bkg y |> List.mem (op (fst e.pos) tile_size)
  || snd e.pos mod tile_size <> 0

let can_go_up bkg e = enemy_no_collisiony bkg e ( + )

let can_go_down bkg e = enemy_no_collisiony bkg e ( - )

let can_go_left bkg e = enemy_no_collisionx bkg e ( - )

let can_go_right bkg e = enemy_no_collisionx bkg e ( + )

let get_direction pl e =
  let pl_pos = curr_pos pl in
  match (fst pl_pos - fst e.pos > 0, snd pl_pos - snd e.pos > 0) with
  | true, true -> [ RIGHT; LEFT; DOWN ]
  | true, false -> [ RIGHT; DOWN; LEFT; UP ]
  | false, true -> [ LEFT; UP; RIGHT; DOWN ]
  | false, false -> [ LEFT; DOWN; RIGHT; UP ]

let rec move_enemy dirs bkg e =
  match dirs with
  | h :: t -> (
      match h with
      | LEFT ->
          if can_go_left bkg e then move_enemy_left e
          else move_enemy t bkg e
      | RIGHT ->
          if can_go_right bkg e then move_enemy_right e
          else move_enemy t bkg e
      | UP ->
          if can_go_up bkg e then move_enemy_up e
          else move_enemy t bkg e
      | DOWN ->
          if can_go_down bkg e then move_enemy_down e
          else move_enemy t bkg e)
  | _ -> failwith "impossible"
