open Yojson.Basic.Util

type obs_id = string

type xy = int * int

type coordinate = {
  x : int;
  y : int;
}

let coord_to_xy coord = (coord.x, coord.y)

type obstacle_one = { coordinate : int * int }

type obstacle_two = { coordinate : int * int }

type t = {
  obs_one_list : obstacle_one list;
  obs_two_list : obstacle_two list;
  start_tile : int * int;
}

let xy_of_json j =
  {
    x = j |> member "x" |> to_string |> int_of_string;
    y = j |> member "y" |> to_string |> int_of_string;
  }

let obs_one_of_json j : obstacle_one =
  {
    coordinate = j |> member "coordinates" |> xy_of_json |> coord_to_xy;
  }

let obs_two_of_json j =
  {
    coordinate = j |> member "coordinates" |> xy_of_json |> coord_to_xy;
  }

let from_json json =
  {
    obs_one_list =
      json
      |> member "obstacle_one_list"
      |> to_list
      |> List.map obs_one_of_json;
    obs_two_list =
      json
      |> member "obstacle_two_list"
      |> to_list
      |> List.map obs_two_of_json;
    start_tile =
      json |> member "start_tile" |> xy_of_json |> coord_to_xy;
  }
