open Background
open Gui
open State
open Player
open Bomb
open Tool_speedup
open Tool_addheart

(** [play_game f] starts the adventure in file [f]. *)

let read_bkg f = from_json (Yojson.Basic.from_file f)

(* let draw_left_panel () = draw_bkg (); draw_board (); draw_heart_3 ();
   draw_head () *)

(* let burn_player pos1 = draw_burnt_pl pos1; Unix.sleepf 10.0 *)

(* let rec bomb_explode st pos1 = match some_explosion st with | true ->
   draw_explosions (exploding st) (get_bkg st) pos1; draw_speedups
   (show_tool1s (exploding st) (get_bkg st)) (* draw_speedups show_tool1
   b bkg move_state2 (clear_exploding st) pos1 *) | false -> () *)

let rec move_state st pos1 =
  clear_tools st;
  draw_score st;
  if check_dead st then draw_lose st
  else if all_cleared st then draw_win st
  else
    match some_explosion st with
    | true ->
        draw_explosions (exploding st) st (player_one st);
        (* draw_speedups (show_tool1s (exploding st) (get_bkg st));
           draw_addhearts (show_tool2s (exploding st) (get_bkg st));
           draw_addbombs (show_tool2s (exploding st) (get_bkg st)); *)
        draw_tools st;
        draw_heart_on_board (player_one st);
        (* draw_minus_heart (exploding st) (player_one st); *)
        move_state (clear_exploding st) pos1
    | false -> (
        clear_tools st;
        let n = take_input st in
        match n with
        | Legal new_st ->
            draw_move new_st
              (curr_pos (player_one st))
              (get_enemy_pos st);
            draw_heart_on_board (player_one new_st);
            move_state new_st (curr_pos (player_one new_st))
        | Make_bomb new_st ->
            draw_bomb (curr_pos (player_one new_st));
            Unix.sleep 1;
            draw_move new_st pos1 (get_enemy_pos st);
            move_state new_st (curr_pos (player_one st))
        | Exit -> ())

(* let rec move_state st pos1 pos2 = draw_move st pos1 pos2; let n =
   take_input st in match n with | Legal new_st -> move_state new_st
   (curr_pos (player_one st)) (curr_pos (player_two st)) | Exit -> () *)

let play_game f =
  print_endline "\n\nWelcome to CS3110 MS";
  draw_canvas ();
  print_endline "canvas";
  draw_instruction ();
  take_start ();
  draw_choose ();
  let bkg = read_bkg f in
  let plr_pos = start_tile_one bkg in
  let plr_type = take_mouse () in
  let st = init_state bkg plr_pos plr_type in
  draw_left_panel ();
  draw_state st;
  move_state st plr_pos

(* let play_game f = print_endline "\n\nWelcome to CS3110 MS";
   draw_canvas (); print_endline "canvas"; draw_bkg (); let bkg =
   read_bkg f in let player1 = start_tile_one bkg in let player2 =
   start_tile_two bkg in

   draw_state (init_state bkg player1 player2); print_endline "tiles";
   let bkg = read_bkg f in let player1 = start_tile_one bkg in let
   player2 = start_tile_two bkg in move_state (init_state bkg player1
   player2) player1 player2 *)

(** [main] prompts for the game to play, then starts it. *)
let main () =
  ANSITerminal.print_string [ ANSITerminal.red ]
    "\n\nWelcome to the 3110 Game engine.\n";
  print_endline
    "Please enter the name of the game file you want to load.\n";
  print_string "> ";
  match read_line () with
  | exception End_of_file -> ()
  | file_name -> play_game file_name

(* Execute the game engine. *)
let () = main ()
