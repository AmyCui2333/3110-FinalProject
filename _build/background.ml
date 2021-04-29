open Yojson.Basic.Util

let tile_size = 40

let tile_number = 16

let move_number = 10

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
  tool : int;
}

type t = {
  obs_list : obstacle list;
  start_pos1 : int * int;
  start_pos2 : int * int;
}

let coord_of_json j =
  {
    x = (j |> member "x" |> to_int |> fun x -> x * tile_size);
    y = (j |> member "y" |> to_int |> fun x -> x * tile_size);
  }

let tool_member s k = match member s k with `Int i -> i | _ -> 0

let obs_of_json j : obstacle =
  {
    id = j |> member "id" |> to_int;
    coordinate =
      j |> member "coordinates" |> coord_of_json |> coord_to_xy;
    obs_type = j |> member "type" |> to_int;
    tool = j |> tool_member "tool";
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

let obs_tool_xy bkg n =
  let obs_tool_list =
    List.filter (fun obs -> obs.tool = n) bkg.obs_list
  in
  List.map (fun obs -> (obs.coordinate, obs.tool)) obs_tool_list

let tool_xy bkg n =
  let obs_tool_list =
    List.filter (fun obs -> obs.tool = n) bkg.obs_list
  in
  List.map (fun obs -> obs.coordinate) obs_tool_list

let obs_one_xy bkg = obs_n_xy bkg 1

let obs_two_xy bkg = obs_n_xy bkg 2

let obs_xy_tool1 bkg = obs_tool_xy bkg 1

let obs_xy_tool2 bkg = obs_tool_xy bkg 2

let tool1_xy bkg = tool_xy bkg 1

let tool2_xy bkg = tool_xy bkg 2

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

let get_tool obs = obs.tool

let check_tool grids bkg =
  List.filter (fun x ->
      List.mem x.coordinate grids = false || x.tool = 1)

let clear_obstacles grids bkg =
  let new_obs =
    List.filter
      (fun x -> List.mem x.coordinate grids = false || x.obs_type = 2)
      bkg.obs_list
  in
  { bkg with obs_list = new_obs }
