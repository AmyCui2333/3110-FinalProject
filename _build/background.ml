open Yojson.Basic.Util

type obs_id = int

type xy = int * int

type coordinate = {
  x : int;
  y : int;
}

let coord_to_xy coord = (coord.x, coord.y)

type obstacle = {
  id : int;
  coordinate : int * int;
  obs_type : int;
}

type t = {
  obs_list : obstacle list;
  start_pos1 : int * int;
  start_pos2 : int * int;
}

let coord_of_json j =
  {
    x = (j |> member "x" |> to_int |> fun x -> x * 40);
    y = (j |> member "y" |> to_int |> fun x -> x * 40);
  }

let obs_of_json j : obstacle =
  {
    id = j |> member "id" |> to_int;
    coordinate =
      j |> member "coordinates" |> coord_of_json |> coord_to_xy;
    obs_type = j |> member "type" |> to_int;
  }

let from_json json =
  {
    obs_list =
      json |> member "obstacle_list" |> to_list |> List.map obs_of_json;
    start_pos1 =
      json |> member "start_1" |> coord_of_json |> coord_to_xy;
    start_pos2 =
      json |> member "start_2" |> coord_of_json |> coord_to_xy;
  }

let lst_to_set lst = lst |> List.sort_uniq Stdlib.compare

let rec ids_of_obs obs = List.map (fun obs -> obs.id) obs

let start_tile_one t = t.start_pos1

let start_tile_two t = t.start_pos2

let obs_ids bkg = ids_of_obs bkg.obs_list

let obs_n_xy bkg n =
  let obs_n_lst =
    List.filter (fun obs -> obs.obs_type = n) bkg.obs_list
  in
  List.map (fun obs -> obs.coordinate) obs_n_lst

let obs_one_xy bkg = obs_n_xy bkg 1

let obs_two_xy bkg = obs_n_xy bkg 2

let get_x (coord : xy) = match coord with a, _ -> a

let get_y (coord : xy) = match coord with _, b -> b

let obs_on_x bkg x =
  let xobs_lst =
    List.filter (fun obs -> get_x obs.coordinate = x) bkg.obs_list
  in
  List.map (fun obs -> get_y obs.coordinate) xobs_lst

let obs_on_y bkg y =
  let yobs_lst =
    List.filter (fun obs -> get_y obs.coordinate = y) bkg.obs_list
  in
  List.map (fun obs -> get_x obs.coordinate) yobs_lst

let clear_obstacles grids bkg =
  let new_obs =
    List.filter (fun x -> List.mem x.coordinate grids) bkg.obs_list
  in
  { bkg with obs_list = new_obs }
