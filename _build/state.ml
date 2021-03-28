open Background
open Player

type t = {
  player_one : Player.t;
  player_two : Player.t;
  bkg : Background.t;
}

let init_state bkg pos1 pos2 =
  let player_one = Player.build_player "one" pos1 in
  let player_two = Player.build_player "two" pos2 in
  { player_one; player_two; bkg }
