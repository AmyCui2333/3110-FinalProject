open Background
open Player
open Graphics
open Bomb
open ToolSpeedUp
open ToolAddHeart
open ToolAddBomb
open ToolTwoBomb
open ObsPortal
open Enemy

type t = {
  player_one : Player.t;
  bkg : Background.t;
  bombs : Bomb.t list;
  bomb_limit : int;
  tool1 : ToolSpeedUp.t list;
  tool2 : ToolAddHeart.t list;
  tool3 : ToolAddBomb.t list;
  tool4 : ToolTwoBomb.t list;
  obsPortal : ObsPortal.t;
  tool1_start_time : float;
  tool1_duration_time : float;
  t_c : bool * (int * int);
  t_c2 : bool * (int * int);
  t_c3 : bool * (int * int);
  t_c4 : bool * (int * int);
  last_enemy : float * string;
  last_enemy_death : float;
  enemy : Enemy.t option;
  score : int;
}

type input =
  | Legal of t
  | Make_bomb of t
  | Exit

let init_state bkg pos1 plr_type =
  {
    player_one = Player.build_player plr_type pos1;
    bkg;
    bombs = [];
    bomb_limit = 1;
    tool1 = [];
    tool2 = [];
    tool3 = [];
    tool4 = [];
    obsPortal = new_portal bkg;
    tool1_start_time = Unix.time () +. max_float;
    tool1_duration_time = 15.0;
    t_c = (false, (0, 0));
    t_c2 = (false, (0, 0));
    t_c3 = (false, (0, 0));
    t_c4 = (false, (0, 0));
    last_enemy = (Unix.time (), "fast");
    last_enemy_death = Unix.time ();
    enemy = None;
    score = 0;
  }

let get_portal_pos st =
  let p1 = get_portal_lower_xy st.obsPortal in
  let p2 = get_portal_upper_xy st.obsPortal in
  [ p1; p2 ]

let get_bkg st = st.bkg

let get_score st = st.score

let player_one t = t.player_one

let get_tool1 st = st.tool1

let get_tool2 st = st.tool2

let get_tool3 st = st.tool3

let get_tool4 st = st.tool4

let get_tool1_xys st = List.map (fun x -> get_speedup_xy x) st.tool1

let get_tool2_xys st = List.map (fun x -> get_addheart_xy x) st.tool2

let get_tool3_xys st = List.map (fun x -> get_bomb_xy x) st.tool3

let get_tool4_xys st = List.map (fun x -> get_twobomb_xy x) st.tool4

let get_tools_xys st = all_tools st.bkg

let move_player_one st p = { st with player_one = p }

let more_bomb b st =
  match b with
  | None -> false
  | Some b -> List.length st.bombs < st.bomb_limit

let add_bomb b st = { st with bombs = b :: st.bombs }

let change_bkg st b = { st with bkg = b }

let change_plr st p = { st with player_one = p }

let change_plr_tool1 st p tool = { (change_plr st p) with tool1 = tool }

let change_plr_tool1_starttime st : t =
  { st with tool1_start_time = Unix.time () }

let change_plr_tool1_starttime_max st : t =
  { st with tool1_start_time = Unix.time () +. max_float }

let check_end st =
  if Unix.time () -. st.tool1_start_time >= st.tool1_duration_time then
    true
  else false

let speedback_plr p st =
  if check_end st then
    change_plr_tool1_starttime_max (change_plr st (change_speed p 10))
  else st

let add_bomb_limit st =
  let old_limit = st.bomb_limit in
  { st with bomb_limit = old_limit + 1 }

let change_bkg_tool1 b tool_lst st =
  let new_st = change_bkg st b in
  { new_st with tool1 = tool_lst }

let change_tool1 st tool_lst = { st with tool1 = tool_lst }

let change_tool2 tool_lst st = { st with tool2 = tool_lst }

let change_plr_tool2 st p tool = { (change_plr st p) with tool2 = tool }

let change_tool3 tool_lst st = { st with tool3 = tool_lst }

let change_plr_tool3 st p tool = { (change_plr st p) with tool3 = tool }

let change_tool4 st tool_lst = { st with tool4 = tool_lst }

let on_tile p =
  fst (curr_pos p) mod tile_size = 0
  && snd (curr_pos p) mod tile_size = 0

let toggle b =
  match fst b with true -> (false, snd b) | false -> (true, snd b)

let toggle_st st = { st with t_c = toggle st.t_c }

let toggle_st2 st = { st with t_c2 = toggle st.t_c2 }

let toggle_st3 st = { st with t_c3 = toggle st.t_c3 }

let toggle_st4 st = { st with t_c4 = toggle st.t_c4 }

let new_t_c a st = { st with t_c = (true, snd a) }

let new_t_c2 a st = { st with t_c2 = (true, snd a) }

let new_t_c3 a st = { st with t_c3 = (true, snd a) }

let new_t_c4 a st = { st with t_c4 = (true, snd a) }

let rec take_tool1 st =
  match st.tool1 with
  | [] -> st
  | h :: t ->
      let to_r =
        tools_collision_gui_return (get_tool1_xys st) st.player_one
      in
      let to_r2 =
        tools_collision_return (get_tool1_xys st) st.player_one
      in
      let to_r3 = to_r <+> to_r2 in
      if fst to_r3 then new_t_c to_r3 st
      else if on_tile st.player_one && fst st.t_c then
        List.filter (fun x -> get_speedup_xy x <> snd st.t_c) st.tool1
        |> change_plr_tool1 st
             (speedup_plr
                (xy_to_speedup (snd st.t_c) st.tool1)
                st.player_one)
        |> change_plr_tool1_starttime |> toggle_st
      else st

let rec take_tool2 st =
  match st.tool2 with
  | [] -> st
  | h :: t ->
      let to_r =
        tools_collision_gui_return (get_tool2_xys st) st.player_one
      in
      let to_r2 =
        tools_collision_return (get_tool2_xys st) st.player_one
      in
      let to_r3 =
        tools_collision_on_grid_return (get_tool2_xys st) st.player_one
      in
      let to_r4 = to_r <+> to_r2 <+> to_r3 in
      if fst to_r4 then new_t_c2 to_r4 st
      else if on_tile st.player_one && fst st.t_c2 then
        List.filter (fun x -> get_addheart_xy x <> snd st.t_c2) st.tool2
        |> change_plr_tool2 st (add st.player_one)
        |> toggle_st2
      else st

let rec take_tool3 st =
  match st.tool3 with
  | [] -> st
  | h :: t ->
      let to_r =
        tools_collision_gui_return (get_tool3_xys st) st.player_one
      in
      let to_r2 =
        tools_collision_return (get_tool3_xys st) st.player_one
      in
      let to_r3 =
        tools_collision_on_grid_return (get_tool3_xys st) st.player_one
      in
      let to_r4 = to_r <+> to_r2 <+> to_r3 in
      if fst to_r4 then new_t_c3 to_r4 st
      else if on_tile st.player_one && fst st.t_c3 then
        st.tool3
        |> List.filter (fun x -> get_bomb_xy x <> snd st.t_c3)
        |> change_plr_tool3 st (bombup_plr st.player_one)
        |> toggle_st3
      else st

let rec take_tool4 st =
  match st.tool4 with
  | [] -> st
  | h :: t ->
      let to_r =
        tools_collision_gui_return (get_tool4_xys st) st.player_one
      in
      let to_r2 =
        tools_collision_return (get_tool4_xys st) st.player_one
      in
      let to_r3 =
        tools_collision_on_grid_return (get_tool4_xys st) st.player_one
      in
      let to_r4 = to_r <+> to_r2 <+> to_r3 in
      if fst to_r4 then new_t_c4 to_r4 st
      else if on_tile st.player_one && fst st.t_c4 then
        st.tool4
        |> List.filter (fun x -> get_twobomb_xy x <> snd st.t_c4)
        |> change_tool4 st |> add_bomb_limit |> toggle_st4
      else st

let take_portal st =
  let p1 = get_portal_lower_xy st.obsPortal in
  let p2 = get_portal_upper_xy st.obsPortal in
  let p_lst = [ p1; p2 ] in
  let to_r = tools_collision_gui_return p_lst st.player_one in
  let to_r2 = tools_collision_return p_lst st.player_one in
  let to_r3 = to_r <+> to_r2 in
  if fst to_r3 then
    p_lst
    |> List.filter (fun x -> x <> snd to_r3)
    |> List.hd |> portal_pos st.obsPortal
    |> transfer_pl st.player_one
    |> change_plr st
  else st

let take_tools st =
  take_tool4 st |> take_tool3 |> take_tool2 |> take_tool1 |> take_portal

let rec some_explosion st =
  match List.filter check_explode st.bombs with
  | [] -> false
  | _ -> true

let exploding st = List.filter check_explode st.bombs

let bombed_player bomb_lst pl =
  if in_blast_lst bomb_lst (curr_pos pl) then kill pl else pl

let rec bombed_obs bomb_lst obs_lst =
  match obs_lst with
  | [] -> []
  | h :: t ->
      if in_blast_lst bomb_lst h then h :: bombed_obs bomb_lst t
      else bombed_obs bomb_lst t

let score_obs exploding st =
  let num_bombed_obs =
    List.length (bombed_obs exploding (obs_one_xy st.bkg))
  in
  let new_score = 10 * num_bombed_obs in
  new_score

let get_area xy =
  match (fst xy - 280 > 0, snd xy - 280 > 0) with
  | true, true -> 1
  | true, false -> 4
  | false, true -> 2
  | false, false -> 3

let random_pos_lst area =
  if area = 1 then [ (40, 40); (40, 560); (560, 40) ]
  else if area = 2 then [ (40, 40); (560, 40); (560, 560) ]
  else if area = 3 then [ (40, 560); (560, 40); (560, 560) ]
  else [ (40, 40); (40, 560); (560, 560) ]

let random_enemy_pos st =
  let ply_pos = curr_pos st.player_one in
  let ply_area = get_area ply_pos in
  let pos_lst = random_pos_lst ply_area in
  let n = Random.int (List.length pos_lst) in
  List.nth pos_lst n

let make_enemy st =
  let new_enemy_pos = random_enemy_pos st in
  let tools = get_tools_xys st in
  let portals = get_portal_pos st in
  if snd st.last_enemy = "fast" then
    (build_enemy new_enemy_pos (tools @ portals) "slow", "slow")
  else (build_enemy new_enemy_pos (tools @ portals) "fast", "fast")

let generate_enemy st =
  if
    Unix.time () -. fst st.last_enemy >= 15.0
    && st.enemy = None
    && Unix.time () -. st.last_enemy_death >= 5.0
  then
    let new_enemy = make_enemy st in
    {
      st with
      enemy = Some (fst new_enemy);
      last_enemy = (Unix.time (), snd new_enemy);
    }
  else st

let bombed_enemy st bomb_lst =
  match st.enemy with
  | Some enemy ->
      if in_blast_lst bomb_lst (enemy_pos enemy) then
        (None, st.score + 200, Unix.time ())
      else (st.enemy, st.score, Unix.time () -. 1000.)
  | None -> (None, st.score, Unix.time () -. 1000.)

let get_enemy_pos st =
  match st.enemy with Some e -> Some (enemy_pos e) | None -> None

let update_enemy_pos st =
  match st.enemy with
  | Some e ->
      let dirs = get_direction st.player_one e in
      let moved_enemy = move_enemy dirs st.bkg e in
      { st with enemy = Some moved_enemy }
  | None -> st

let change_exploding_state
    st
    bombs_left
    new_bkg
    new_ply
    new_enemy
    new_score
    enemy_death
    new_score2
    tool1_lst
    tool2_lst
    tool3_lst
    tool4_lst =
  {
    st with
    bombs = bombs_left;
    player_one = new_ply;
    enemy = new_enemy;
    score = new_score + new_score2;
    tool4 = tool4_lst;
    last_enemy_death = enemy_death;
  }
  |> change_bkg_tool1 new_bkg tool1_lst
  |> change_tool2 tool2_lst |> change_tool3 tool3_lst

let clear_exploding st =
  let exploding = List.filter check_explode st.bombs in
  let bombs_left =
    List.filter (fun x -> check_explode x = false) st.bombs
  in
  let new_bkg = explode st.bkg exploding in
  let new_ply = bombed_player exploding st.player_one in
  let new_enemy, new_score, last_death = bombed_enemy st exploding in
  let tool1_xy_lst = show_tools exploding st.bkg 1 in
  let tool2_xy_lst = show_tools exploding st.bkg 2 in
  let tool3_xy_lst = show_tools exploding st.bkg 3 in
  let tool4_xy_lst = show_tools exploding st.bkg 4 in
  let tool1_lst = new_speedups_fromxy tool1_xy_lst @ st.tool1 in
  let tool2_lst = new_addhearts_fromxy tool2_xy_lst @ st.tool2 in
  let tool3_lst = new_addbombs_fromxy tool3_xy_lst @ st.tool3 in
  let tool4_lst = new_twobombs_fromxy tool4_xy_lst @ st.tool4 in
  let new_score2 = score_obs exploding st in
  change_exploding_state st bombs_left new_bkg new_ply new_enemy
    new_score last_death new_score2 tool1_lst tool2_lst tool3_lst
    tool4_lst

let check_dead st = lives (player_one st) = 0

let generate_bomb st =
  let new_b = make_bomb st.player_one in
  if more_bomb (make_bomb st.player_one) st then
    match new_b with
    | None -> failwith "impossible"
    | Some b -> Make_bomb (add_bomb b st)
  else Legal st

let enemy_ply_collision st =
  let player = st.player_one in
  match st.enemy with
  | Some e ->
      let new_ply, new_enemy = collide_with_player player e in
      { st with enemy = new_enemy; player_one = new_ply }
  | None -> st

let all_cleared st =
  if
    obs_one_xy st.bkg = []
    && st.tool1 = [] && st.tool2 = [] && st.tool3 = [] && st.tool4 = []
    && st.enemy = None
  then true
  else false

let update_state_enemy st =
  st |> generate_enemy |> update_enemy_pos |> enemy_ply_collision

let update_state st collision_dir =
  Legal
    (move_player_one st (collision_dir st.bkg st.player_one)
    |> update_state_enemy |> take_tools
    |> speedback_plr st.player_one)

let in_area (mouse_x, mouse_y) a b c d =
  a < mouse_x && mouse_x < a + c && b < mouse_y && mouse_y < b + d

let in_plr_1 (x, y) = in_area (x, y) 135 207 189 189

let in_plr_2 (x, y) = in_area (x, y) 456 207 189 189

let in_easy (x, y) = in_area (x, y) 160 282 92 60

let in_normal (x, y) = in_area (x, y) 325 282 136 60

let in_hard (x, y) = in_area (x, y) 535 282 100 60

let rec take_map () =
  let input = wait_next_event [ Button_down ] in
  let x, y = (input.mouse_x, input.mouse_y) in
  if in_easy (x, y) then "easy.json"
  else if in_normal (x, y) then "normal.json"
  else if in_hard (x, y) then "hard.json"
  else take_map ()

let rec take_start () =
  let _ = wait_next_event [ Button_down ] in
  ()

let rec take_mouse () =
  let input = wait_next_event [ Button_down ] in
  let x, y = (input.mouse_x, input.mouse_y) in
  if in_plr_1 (x, y) then "lama"
  else if in_plr_2 (x, y) then "caml"
  else take_mouse ()

let rec take_input st =
  let input = wait_next_event [ Key_pressed ] in
  match input.key with
  | 'w' -> update_state st no_collision_up
  | 's' -> update_state st no_collision_down
  | 'a' -> update_state st no_collision_left
  | 'd' -> update_state st no_collision_right
  | ' ' -> generate_bomb st
  | _ -> take_input st
