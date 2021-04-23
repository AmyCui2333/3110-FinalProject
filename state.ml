open Background
open Player
open Graphics
open Bomb
open Tool_speedup

type t = {
  player_one : Player.t;
  (* player_two : Player.t; *)
  bkg : Background.t;
  bombs : Bomb.t list;
  bomb_limit : int;
  tool1 : Tool_speedup.t list;
}

type input =
  | Legal of t
  | Make_bomb of t
  | Exit

let init_state bkg pos1 =
  let player_one = Player.build_player "one" pos1 in
  (* let player_two = Player.build_player "two" pos2 in *)
  { player_one; bkg; bombs = []; bomb_limit = 1; tool1 = [] }

(* let init_state bkg pos1 pos2 = let player_one = Player.build_player
   "one" pos1 in let player_two = Player.build_player "two" pos2 in {
   player_one; player_two; bkg } *)

let get_bkg st = st.bkg

let player_one t = t.player_one

(* let player_two t = t.player_two *)

let get_tool1_xys st = List.map (fun x -> get_xy x) st.tool1

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

let change_bkg_tool st b tool_lst =
  let new_st = change_bkg st b in
  { new_st with tool1 = tool_lst }

(* let rec clear_tool1 st = match st.tool1 with | [] -> [] | h :: t ->
   if tool_collision (get_xy h) st.player_one then clear_tool1 st else h
   :: clear_tool1 st *)

let rec take_tool1 st =
  match st.tool1 with
  | [] -> st
  | h :: t ->
      if tool_collision (get_xy h) st.player_one then
        change_plr st (speedup_plr h st.player_one)
        (* (clear_tool1 st) *)
      else st

(* let tool1_expire st = *)

let rec some_explosion st =
  match List.filter check_explode st.bombs with
  | [] -> false
  | _ -> true

let exploding st = List.filter check_explode st.bombs

(*clear the exploding bushes while add tools to st*)
let clear_exploding st =
  let exploding = List.filter check_explode st.bombs in
  let left = List.filter (fun x -> check_explode x = false) st.bombs in
  let new_bkg = explode st.bkg exploding in
  let tool1_xy_lst = show_tool1s exploding st.bkg in
  let tool1_lst = new_speedups_fromxy tool1_xy_lst in
  change_bkg_tool { st with bombs = left } new_bkg tool1_lst

(* let clear_exploding st = let exploding = List.filter check_explode
   st.bombs in let left = List.filter (fun x -> check_explode x = false)
   st.bombs in let new_bkg = explode st.bkg exploding in let
   tool1_xy_lst = show_tool1s exploding st.bkg in let tool1_lst =
   new_speedups_fromxy tool1_xy_lst in change_bkg { st with bombs = left
   } new_bkg *)

(* let exploding_add_tool st = clear_graph st |> *)

let rec take_input st =
  let input = wait_next_event [ Key_pressed ] in
  match input.key with
  | 'w' ->
      Legal (move_player_one st (no_collision_up st.bkg st.player_one))
      (* |> take_tool1) *)
  | 's' ->
      Legal
        (move_player_one st (no_collision_down st.bkg st.player_one))
      (* |> take_tool1) *)
  | 'a' ->
      Legal
        (move_player_one st (no_collision_left st.bkg st.player_one))
      (* |> take_tool1) *)
  | 'd' ->
      Legal
        (move_player_one st (no_collision_right st.bkg st.player_one))
      (* |> take_tool1) *)
  | ' ' ->
      let new_b = make_bomb st.player_one in
      if more_bomb (make_bomb st.player_one) st then
        match new_b with
        | None -> failwith "impossible"
        | Some b -> Make_bomb (add_bomb b st)
      else Legal st
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
