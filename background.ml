open Yojson.Basic.Util

   type obs_id = int

   type xy = int * int

   type coordinate = { x : int; y : int; }

   let coord_to_xy coord = (coord.x, coord.y)

   type obstacle = { id : int; coordinate : int * int; obs_type : int; }

   type t = { obs_list : obstacle list; start_tile : int * int; }

   let coord_of_json j = { x = (j |> member "x" |> to_string |>
   int_of_string |> fun x -> x * 50); y = (j |> member "y" |> to_string
   |> int_of_string |> fun x -> x * 50); }

   let obs_of_json j : obstacle = { id = j |> member "id" |> to_int;
   coordinate = j |> member "coordinates" |> xy_of_json |> coord_to_xy;
   obs_type = j |> member "type" |> to_int; } 
   
   let from_json json =
   { obs_list = json |> member "obstacle_list" |> to_list |> List.map
   obs_of_json; start_tile = json |> member "start_tile" |> xy_of_json
   |> coord_to_xy; }

   let lst_to_set lst = lst |> List.sort_uniq Stdlib.compare

   let rec ids_of_obs obs = List.map (fun obs -> obs.id) obs

   let start_tile t = t.start_tile

   let obs_ids bkg = ids_of_obs bkg.obs_list

   let obs_n_xy bkg n = let obs_n_lst = List.filter (fun obs ->
   obs.obs_type = n) bkg.obs_list in List.map (fun obs ->
   obs.coordinate) obs_n_lst

   let obs_one_xy bkg = obs_n_xy bkg 1

   let obs_two_xy bkg = obs_n_xy bkg 2
