open Background

type t = {
  current : xy;
  obs : obs_ids list;
}

let start_state bkg =
  let start = start_tile bkg in
  let obs_list = obs_ids bkg in
  { current = start; obs = obs_list }