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
  coordinate : int * int;
  obs_type : int;
  tool : int;
}

type t = {
  obs_list : obstacle list;
  start_pos : int * int;
  portal1 : int * int;
  portal2 : int * int;
  tools_xy : xy list;
}

let coord_of_json j =
  {
    x = (j |> member "x" |> to_int |> fun x -> x * tile_size);
    y = (j |> member "y" |> to_int |> fun x -> x * tile_size);
  }

let tool_member s k = match member s k with `Int i -> i | _ -> 0

let obs_of_json j : obstacle =
  {
    coordinate =
      j |> member "coordinates" |> coord_of_json |> coord_to_xy;
    obs_type = j |> member "type" |> to_int;
    tool = j |> tool_member "tool";
  }

let all_tools_xy obs_lst =
  let tools =
    List.filter
      (fun obs ->
        obs.tool = 1 || obs.tool = 2 || obs.tool = 3 || obs.tool = 4)
      obs_lst
  in
  List.map (fun obs -> obs.coordinate) tools

let from_json json =
  {
    obs_list =
      json |> member "obstacle_list" |> to_list |> List.map obs_of_json;
    start_pos = json |> member "start" |> coord_of_json |> coord_to_xy;
    portal1 =
      json |> member "portal_lower" |> coord_of_json |> coord_to_xy;
    portal2 =
      json |> member "portal_upper" |> coord_of_json |> coord_to_xy;
    tools_xy =
      json |> member "obstacle_list" |> to_list |> List.map obs_of_json
      |> all_tools_xy;
  }

let start_tile_one t = t.start_pos

let obs_n_xy bkg n =
  let obs_n_lst =
    List.filter (fun obs -> obs.obs_type = n) bkg.obs_list
  in
  List.map (fun obs -> obs.coordinate) obs_n_lst

let obs_tool_xy bkg i =
  let obs_tool_list =
    List.filter (fun obs -> obs.tool = i) bkg.obs_list
  in
  List.map (fun obs -> (obs.coordinate, obs.tool)) obs_tool_list

let tool_xy bkg i =
  let obs_tool_list =
    List.filter (fun obs -> obs.tool = i) bkg.obs_list
  in
  List.map (fun obs -> obs.coordinate) obs_tool_list

let all_tools bkg = bkg.tools_xy

let obs_one_xy bkg = obs_n_xy bkg 1

let obs_two_xy bkg = obs_n_xy bkg 2

let obs_three_xy bkg = [ bkg.portal1; bkg.portal2 ]

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

let check_tool tiles bkg =
  List.filter (fun x ->
      List.mem x.coordinate tiles = false || x.tool = 1)

let clear_obstacles tiles bkg =
  let new_obs =
    List.filter
      (fun x -> List.mem x.coordinate tiles = false || x.obs_type = 2)
      bkg.obs_list
  in
  { bkg with obs_list = new_obs }
