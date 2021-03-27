open Background 

type obs_id = int

type t = {
  current : int * int;
  obs : obs_id list
}

let start_state bkg =
  let start = start_tile bkg in 
  let obs_list = obs_ids bkg in
  { current = start; obs = obs_list }