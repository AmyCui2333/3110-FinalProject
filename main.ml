open Background
open Gui
open State
open Player
open Bomb
open ToolSpeedUp
open ToolAddHeart

let read_bkg f = from_json (Yojson.Basic.from_file f)

let rec move_state st pos1 =
  clear_tools st;
  draw_score st;
  if check_dead st then (
    draw_ending st false;
    print_endline "\n~ Game Over 🐫 Try Again ~")
  else if all_cleared st then (
    draw_ending st true;
    print_endline "\n~ Game Completed 🐫 You Won ~\n\n")
  else
    match some_explosion st with
    | true ->
        draw_explosions (exploding st) st (player_one st);
        draw_tools st;
        draw_heart_on_board (player_one st);
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

let play_game f =
  draw_choose ();
  let bkg = read_bkg f in
  let plr_pos = start_tile_one bkg in
  let plr_type = take_mouse () in
  let st = init_state bkg plr_pos plr_type in
  draw_left_panel st;
  draw_state st;
  move_state st plr_pos

(** [main] prompts for the game to play, then starts it. *)
let main () =
  ANSITerminal.print_string [ ANSITerminal.red ]
    "\n\nWelcome to the 🐫 3110 Game engine.\n";
  print_endline
    "Please enter the name of the game file you want to load.";
  print_endline
    "You can type \"easy.json\" (friendly for new players), \
     \"normal.json\", or \"hard.json\", and press \"enter\" key to \
     start the game!\n";

  (* print_string "> "; *)
  print_endline "\n~ Game has started ~";
  draw_canvas ();
  draw_instruction ();
  take_start ();
  draw_choose_map ();
  let file_name = take_map () in
  play_game file_name

(* Execute the game engine. *)
let () = main ()
