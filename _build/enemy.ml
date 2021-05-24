open Background
open Player

type direction =
  | LEFT
  | RIGHT
  | UP
  | DOWN

let slow_speed = 10

let fast_speed = 20

type t = {
  speed : int;
  pos : int * int;
  off_tiles : (int * int) list;
}

let enemy_pos e = e.pos

let enemy_speed e = e.speed

let build_enemy pos off_tiles t =
  if t = "fast" then { speed = fast_speed; pos; off_tiles }
  else { speed = slow_speed; pos; off_tiles }

let move_enemy_up e = { e with pos = (fst e.pos, snd e.pos + e.speed) }

let move_enemy_down e =
  { e with pos = (fst e.pos, snd e.pos - e.speed) }

let move_enemy_left e =
  { e with pos = (fst e.pos - e.speed, snd e.pos) }

let move_enemy_right e =
  { e with pos = (fst e.pos + e.speed, snd e.pos) }

let obs_tools_on_x e bkg x =
  let obs = obs_on_x bkg x in
  let tools = List.filter (fun tile -> fst tile = x) e.off_tiles in
  let tools_y = List.map snd tools in
  obs @ tools_y

let obs_tools_on_y e bkg y =
  let obs = obs_on_y bkg y in
  let tools = List.filter (fun tile -> snd tile = y) e.off_tiles in
  let tools_x = List.map fst tools in
  obs @ tools_x

let enemy_collisiony bkg e op =
  let x = fst e.pos in
  obs_tools_on_x e bkg x |> List.mem (op (snd e.pos) tile_size)
  || fst e.pos mod tile_size <> 0

let enemy_collisionx bkg e op =
  let y = snd e.pos in
  obs_tools_on_y e bkg y |> List.mem (op (fst e.pos) tile_size)
  || snd e.pos mod tile_size <> 0

let can_go_up bkg e = not (enemy_collisiony bkg e ( + ))

let can_go_down bkg e = not (enemy_collisiony bkg e ( - ))

let can_go_left bkg e = not (enemy_collisionx bkg e ( - ))

let can_go_right bkg e = not (enemy_collisionx bkg e ( + ))

let get_direction pl e =
  let pl_pos = curr_pos pl in
  if fst pl_pos - fst e.pos = 0 && snd pl_pos - snd e.pos > 0 then
    [ UP; RIGHT; DOWN; LEFT ]
  else if fst pl_pos - fst e.pos = 0 && snd pl_pos - snd e.pos < 0 then
    [ DOWN; RIGHT; UP; LEFT ]
  else if fst pl_pos - fst e.pos > 0 && snd pl_pos - snd e.pos = 0 then
    [ RIGHT; DOWN; LEFT; UP ]
  else if fst pl_pos - fst e.pos < 0 && snd pl_pos - snd e.pos = 0 then
    [ LEFT; DOWN; RIGHT; UP ]
  else
    match (fst pl_pos - fst e.pos > 0, snd pl_pos - snd e.pos > 0) with
    | true, true -> [ RIGHT; UP; LEFT; DOWN ]
    | true, false -> [ DOWN; RIGHT; UP; LEFT ]
    | false, true -> [ LEFT; UP; RIGHT; DOWN ]
    | false, false -> [ DOWN; LEFT; UP; RIGHT ]

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

let collide_with_player pl enemy =
  let ply_x, ply_y = curr_pos pl in
  let enemy_x = fst enemy.pos in
  let enemy_y = snd enemy.pos in
  if
    enemy_x < ply_x + 40
    && enemy_x > ply_x - 40
    && enemy_y < ply_y + 40
    && enemy_y > ply_y - 40
  then (kill pl, None)
  else (pl, Some enemy)
