open Background
open Player
open Graphics
open Bomb
open Tool_speedup
open Tool_addheart
open Tool_addbomb
open Obs_portal
open Enemy

type t = {
  player_one : Player.t;
  bkg : Background.t;
  bombs : Bomb.t list;
  bomb_limit : int;
  tool1 : Tool_speedup.t list;
  tool2 : Tool_addheart.t list;
  tool3 : Tool_addbomb.t list;
  obs_portal : Obs_portal.t;
  tool1_start_time : float;
  tool1_duration_time : float;
  t_c : bool * (int * int);
  t_c2 : bool * (int * int);
  t_c3 : bool * (int * int);
  last_enemy : float * string;
  enemy : Enemy.t option;
  score : int;
}

type input =
  | Legal of t
  | Make_bomb of t
  | Exit

let init_state bkg pos1 =
  (* let player_one = Player.build_player "one" pos1 in let player_two =
     Player.build_player "two" pos2 in *)
  {
    player_one = Player.build_player "one" pos1;
    bkg;
    bombs = [];
    bomb_limit = 1;
    tool1 = [];
    tool2 = [];
    tool3 = [];
    obs_portal = new_portal bkg;
    tool1_start_time = Unix.time () +. max_float;
    tool1_duration_time = 15.0;
    t_c = (false, (0, 0));
    t_c2 = (false, (0, 0));
    t_c3 = (false, (0, 0));
    last_enemy = (Unix.time (), "fast");
    enemy = None;
    score = 0;
  }

  let get_portal_pos st = let p1 = get_portal1_xy st.obs_portal in
  let p2 = get_portal2_xy st.obs_portal in
[ p1; p2 ]

(* let init_state bkg pos1 pos2 = let player_one = Player.build_player
   "one" pos1 in let player_two = Player.build_player "two" pos2 in {
   player_one; player_two; bkg } *)

let get_bkg st = st.bkg

let get_score st = st.score

let player_one t = t.player_one

(* let player_two t = t.player_two *)

let get_tool1 st = st.tool1

let get_tool2 st = st.tool2

let get_tool3 st = st.tool3

let get_tool1_xys st = List.map (fun x -> get_speedup_xy x) st.tool1

let get_tool2_xys st = List.map (fun x -> get_addheart_xy x) st.tool2

let get_tool3_xys st = List.map (fun x -> get_bomb_xy x) st.tool3

let get_tools_xys st = all_tools st.bkg

let move_player_one st p = { st with player_one = p }

let more_bomb b st =
  match b with
  | None -> false
  | Some b -> List.length st.bombs < st.bomb_limit

let add_bomb b st = { st with bombs = b :: st.bombs }

(* let move_player_two st p = { st with player_two = p } *)
let add_tool1 t_lst st = { st with tool1 = t_lst @ st.tool1 }

let add_tool1s st = add_tool1 (new_speedups st.bombs st.bkg) st

let change_bkg st b = { st with bkg = b }

let change_plr st p = { st with player_one = p }

let change_plr_tool1 st p tool = { (change_plr st p) with tool1 = tool }

let change_plr_tool1_starttime st : t =
  { st with tool1_start_time = Unix.time () }

let change_plr_tool1_starttime_max st : t =
  { st with tool1_start_time = Unix.time () +. max_float }

(* let change_plr_tool1_duration st : t = { st with tool1_duration_time
   = 5.0 } *)

let check_end st =
  if Unix.time () -. st.tool1_start_time >= st.tool1_duration_time then
    true
  else false

let speedback_plr p st =
  if check_end st then
    change_plr_tool1_starttime_max (change_plr st (change_speed p 10))
  else st

let change_plr_tool2 st p tool = { (change_plr st p) with tool2 = tool }

let change_bkg_tool1 st b tool_lst =
  let new_st = change_bkg st b in
  { new_st with tool1 = tool_lst }

let change_tool2 st tool_lst = { st with tool2 = tool_lst }

let change_tool3 st tool_lst = { st with tool3 = tool_lst }

let change_plr_tool3 st p tool = { (change_plr st p) with tool3 = tool }

(* let rec clear_tool1 st = match st.tool1 with | [] -> [] | h :: t ->
   if tool_collision (get_xy h) st.player_one then clear_tool1 st else h
   :: clear_tool1 st *)

(*TODO: rn only work for one tool*)
(* let rec take_tool1_old st = match st.tool1 with | [] -> st | h :: t
   -> if tool_collision (get_speedup_xy h) st.player_one then
   change_plr_tool st (speedup_plr h st.player_one) (List.filter (fun x
   -> get_speedup_xy x <> get_speedup_xy h) st.tool1) (* (clear_tool1
   st) *) else st *)

let on_grid p =
  fst (curr_pos p) mod tile_size = 0
  && snd (curr_pos p) mod tile_size = 0

let toggle b =
  match fst b with true -> (false, snd b) | false -> (true, snd b)

let toggle_st st = { st with t_c = toggle st.t_c }

let toggle_st2 st = { st with t_c2 = toggle st.t_c2 }

let toggle_st3 st = { st with t_c3 = toggle st.t_c3 }

let new_t_c a st = { st with t_c = (true, snd a) }

let new_t_c2 a st = { st with t_c2 = (true, snd a) }

let new_t_c3 a st = { st with t_c3 = (true, snd a) }

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
      else if on_grid st.player_one && fst st.t_c then
        List.filter (fun x -> get_speedup_xy x <> snd st.t_c) st.tool1
        |> change_plr_tool1 st
             (speedup_plr
                (xy_to_speedup (snd st.t_c) st.tool1)
                st.player_one)
        |> change_plr_tool1_starttime
        (* |> change_plr_tool1_duration *)
        |> toggle_st
      else st

(* let tool1_speedback st = if check_end st then change_speed p
   (get_speed p / 2) else p *)

let rec take_tool2 st =
  match st.tool2 with
  | [] -> st
  | h :: t ->
      let to_r =
        tools_collision_gui_return (get_tool2_xys st) st.player_one
      in
      (* print_endline (string_of_bool (fst to_r)); *)
      let to_r2 =
        tools_collision_return (get_tool2_xys st) st.player_one
      in
      (* print_endline (string_of_bool (fst to_r2)); *)
      let to_r3 = to_r <+> to_r2 in
      (* print_endline (string_of_bool (fst to_r3)); *)
      if fst to_r3 then new_t_c2 to_r3 st
      else if on_grid st.player_one && fst st.t_c2 then
        List.filter (fun x -> get_addheart_xy x <> snd st.t_c2) st.tool2
        |> change_plr_tool2 st (add st.player_one)
        |> toggle_st2
        (* (add (xy_to_addheart (snd st.t_c) st.tool2) st.player_one)
           (List.filter (fun x -> get_speedup_xy x <> snd st.t_c)
           st.tool1) (clear_tool1 st) *)
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
      let to_r3 = to_r <+> to_r2 in
      print_endline (string_of_bool (fst to_r3));
      if fst to_r3 then new_t_c3 to_r3 st
      else if on_grid st.player_one && fst st.t_c3 then
        List.filter (fun x -> get_bomb_xy x <> snd st.t_c3) st.tool3
        |> change_plr_tool3 st (bombup_plr st.player_one)
        (* List.filter (fun x -> get_bomb_xy x = snd st.t_c3) st.tool3)) *)
        |> toggle_st3
      else st

let take_portal st =
  let p1 = get_portal1_xy st.obs_portal in
  let p2 = get_portal2_xy st.obs_portal in
  let p_lst = [ p1; p2 ] in
  let to_r = tools_collision_gui_return p_lst st.player_one in
  let to_r2 = tools_collision_return p_lst st.player_one in
  let to_r3 = to_r <+> to_r2 in
  if fst to_r3 then
    change_plr st
      (transfer_pl st.player_one
         (portal_pos
            (List.hd (List.filter (fun x -> x <> snd to_r3) p_lst))
            st.obs_portal))
  else st

  (* let rec clean_bombs res b_lst =
    match b_lst with
    | [] -> res
    | h :: t ->
        clean_bombs
          (List.append (get_pos h :: get_neighbours 1 h []) res)
          t  
          
          
let pos_lst = clean_bombs [] b_lst in
  let grids = grids_to_clean pos_lst bkg in *)

(* let rec take_tool1_ st = match st.tool1 with | [] -> st | h :: t ->
   let to_r = tools_collision_return (get_tool1_xys st) st.player_one in
   if fst to_r then change_plr_tool1 st (speedup_plr (xy_to_speedup (snd
   to_r) st.tool1) st.player_one) (List.filter (fun x -> get_speedup_xy
   x <> snd to_r) st.tool1) (* (clear_tool1 st) *) else st *)

(* let tool1_expire st = *)
let take_tools st =
  take_tool3 st |> take_tool2 |> take_tool1 |> take_portal

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
    print_endline (string_of_bool (in_blast_lst bomb_lst h ) );
    if in_blast_lst bomb_lst h 
    then h :: bombed_obs bomb_lst t else bombed_obs bomb_lst t 

let score_obs exploding st=
  (* let exploding = List.filter check_explode st.bombs in *)
  (* print_endline (to_string check_explode); *)
  let num_bombed_obs = List.length (bombed_obs exploding (obs_one_xy st.bkg)) in
  let new_score  =10* num_bombed_obs in
  new_score
  (* print_endline (string_of_int (List.length (obs_one_xy st.bkg)));
  print_endline (string_of_int (List.length exploding));
  print_endline (string_of_int (num_bombed_obs));  *)
  (* Bug lies here? *)
  (* {st with score = new_score} *)

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
  if Unix.time () -. fst st.last_enemy >= 10.0 && st.enemy = None then
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
        (None, st.score + 200)
      else (st.enemy, st.score)
  | None -> (None, st.score)

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
    new_score2
    tool1_lst
    tool2_lst
    tool3_lst =
  change_tool3
    (change_tool2
       (change_bkg_tool1
          {
            st with
            bombs = bombs_left;
            player_one = new_ply;
            enemy = new_enemy;
            score = new_score + new_score2;
          }
          new_bkg tool1_lst)
       tool2_lst)
    tool3_lst

(**clear the exploding bushes while add tools to st if any*)
let clear_exploding st =
  let exploding = List.filter check_explode st.bombs in
  let bombs_left =
    List.filter (fun x -> check_explode x = false) st.bombs
  in
  (* let tool1_xy_lst = show_tool1s exploding st.bkg in *)
  let new_bkg = explode st.bkg exploding in
  let new_ply = bombed_player exploding st.player_one in
  let new_enemy, new_score = bombed_enemy st exploding in
  let tool1_xy_lst = show_tool1s exploding st.bkg in
  let tool2_xy_lst = show_tool2s exploding st.bkg in
  let tool3_xy_lst = show_tool3s exploding st.bkg in
  let tool1_lst = new_speedups_fromxy tool1_xy_lst @ st.tool1 in
  let tool2_lst = new_addhearts_fromxy tool2_xy_lst @ st.tool2 in
  let tool3_lst = new_addbombs_fromxy tool3_xy_lst @ st.tool3 in
  let new_score2 = score_obs exploding st in 
  change_exploding_state st bombs_left new_bkg new_ply new_enemy
    new_score new_score2 tool1_lst tool2_lst tool3_lst

(* print_endline (string_of_int(List.length tool1_xy_lst)) *)

(* let exploding_add_tool st = clear_graph st |> *)

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
    let new_ply, new_enemy = collide_with_player player e 
    in {st with enemy = new_enemy; player_one = new_ply}
  | None -> st


let update_state_enemy st = 
  st |> generate_enemy |> update_enemy_pos |> enemy_ply_collision


let update_state st collision_dir =
  Legal
    (move_player_one st (collision_dir st.bkg st.player_one)
    |> update_state_enemy
    |> take_tools
    |> speedback_plr st.player_one)

let rec take_input st =
  let input = wait_next_event [ Key_pressed ] in
  match input.key with
  | 'w' -> update_state st no_collision_up
  | 's' -> update_state st no_collision_down
  | 'a' -> update_state st no_collision_left
  | 'd' -> update_state st no_collision_right
  | ' ' -> generate_bomb st
  | _ -> take_input st

(* let rec take_input st = let input = wait_next_event [ Key_pressed ]
   in let _ = print_endline "taking input" in match input.key with | 'w'
   -> print_endline "w"; Legal (move_player_one st (no_collision_up
   st.bkg st.player_one st.player_two)) | 's' -> print_endline "s";
   Legal (move_player_one st (no_collision_down st.bkg st.player_one
   st.player_two)) | 'a' -> Legal (move_player_one st (no_collision_left
   st.bkg st.player_one st.player_two)) | 'd' -> Legal (move_player_one
   st (no_collision_right st.bkg st.player_one st.player_two)) | 'i' ->
   print_endline "i"; Legal (move_player_two st (no_collision_up st.bkg
   st.player_two st.player_one)) | 'k' -> print_endline "k"; Legal
   (move_player_two st (no_collision_down st.bkg st.player_two
   st.player_one)) | 'j' -> Legal (move_player_two st (no_collision_left
   st.bkg st.player_two st.player_one)) | 'l' -> Legal (move_player_two
   st (no_collision_right st.bkg st.player_two st.player_one)) | _ ->
   Exit *)
