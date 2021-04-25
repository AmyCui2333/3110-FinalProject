open Background
open Gui
open State
open Player
open Bomb
open Tool_speedup

(** [play_game f] starts the adventure in file [f]. *)

let read_bkg f = from_json (Yojson.Basic.from_file f)

(* let burn_player pos1 = draw_burnt_pl pos1; Unix.sleepf 10.0 *)

(* let rec bomb_explode st pos1 = match some_explosion st with | true ->
   draw_explosions (exploding st) (get_bkg st) pos1; draw_speedups
   (show_tool1s (exploding st) (get_bkg st)) (* draw_speedups show_tool1
   b bkg move_state2 (clear_exploding st) pos1 *) | false -> () *)

let rec move_state st pos1 =
  clear_speedup st;
  if check_dead st then ()
  else
    match some_explosion st with
    | true ->
        draw_explosions (exploding st) (get_bkg st) pos1;
        draw_speedups (show_tool1s (exploding st) (get_bkg st));
        draw_minus_heart (exploding st) (player_one st);
        move_state (clear_exploding st) pos1
    | false -> (
        let n = take_input st in
        match n with
        | Legal new_st ->
            draw_move new_st (curr_pos (player_one st));
            move_state new_st (curr_pos (player_one new_st))
        | Make_bomb new_st ->
            draw_bomb (curr_pos (player_one new_st));
            Unix.sleep 1;
            draw_move new_st pos1;
            move_state new_st (curr_pos (player_one st))
        | Exit -> ())

(* let rec move_state st pos1 pos2 = draw_move st pos1 pos2; let n =
   take_input st in match n with | Legal new_st -> move_state new_st
   (curr_pos (player_one st)) (curr_pos (player_two st)) | Exit -> () *)

let play_game f =
  print_endline "\n\nWelcome to CS3110 MS";
  draw_canvas ();
  print_endline "canvas";
  draw_bkg ();
  draw_board ();
  draw_heart_3 ();
  draw_head ();
  let bkg = read_bkg f in
  let player1 = start_tile_one bkg in

  draw_state (init_state bkg player1);
  print_endline "tiles";
  let bkg = read_bkg f in
  let player1 = start_tile_one bkg in

  move_state (init_state bkg player1) player1

(* let play_game f = print_endline "\n\nWelcome to CS3110 MS";
   draw_canvas (); print_endline "canvas"; draw_bkg (); let bkg =
   read_bkg f in let player1 = start_tile_one bkg in let player2 =
   start_tile_two bkg in

   draw_state (init_state bkg player1 player2); print_endline "tiles";
   let bkg = read_bkg f in let player1 = start_tile_one bkg in let
   player2 = start_tile_two bkg in move_state (init_state bkg player1
   player2) player1 player2 *)

(** [main ()] prompts for the game to play, then starts it. *)
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
