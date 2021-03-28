open Background
open Gui

(** [play_game f] starts the adventure in file [f]. *)

let read_bkg f = from_json (Yojson.Basic.from_file f)

let play_game f =
  print_endline "\n\nWelcome to CS3110 MS";
  draw_canvas ();
  print_endline "canvas";

  draw_bkg ();
  print_endline "tiles";
  draw_obs f;
  draw_plr (init_p1_xy f);
  input f

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
