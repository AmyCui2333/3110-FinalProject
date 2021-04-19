open Background
open Player
open Graphics

type t = {
  player_one : Player.t;
  player_two : Player.t;
  bkg : Background.t;
}

type input =
  | Legal of t
  | Exit

let init_state bkg pos1 pos2 =
  let player_one = Player.build_player "one" pos1 in
  let player_two = Player.build_player "two" pos2 in
  { player_one; player_two; bkg }

let get_bkg st = st.bkg

let player_one t = t.player_one

let player_two t = t.player_two

let move_player_one st p = { st with player_one = p }

let move_player_two st p = { st with player_two = p }

let rec take_input st =
  let input = wait_next_event [ Key_pressed ] in
  let _ = print_endline "taking input" in
  match input.key with
  | 'w' ->
      print_endline "w";
      Legal
        (move_player_one st
           (no_collision_up st.bkg st.player_one st.player_two))
  | 's' ->
      print_endline "s";
      Legal
        (move_player_one st
           (no_collision_down st.bkg st.player_one st.player_two))
  | 'a' ->
      Legal
        (move_player_one st
           (no_collision_left st.bkg st.player_one st.player_two))
  | 'd' ->
      Legal
        (move_player_one st
           (no_collision_right st.bkg st.player_one st.player_two))
  | 'i' ->
      print_endline "i";
      Legal
        (move_player_two st
           (no_collision_up st.bkg st.player_two st.player_one))
  | 'k' ->
      print_endline "k";
      Legal
        (move_player_two st
           (no_collision_down st.bkg st.player_two st.player_one))
  | 'j' ->
      Legal
        (move_player_two st
           (no_collision_left st.bkg st.player_two st.player_one))
  | 'l' ->
      Legal
        (move_player_two st
           (no_collision_right st.bkg st.player_two st.player_one))
  | _ -> Exit
