open Graphics
open Images

(* open Images.Png *)
(* open Images.Png *)
open Background
open Player
open State
open Bomb
open Tool_speedup

let read_bkg f = from_json (Yojson.Basic.from_file f)

(**********************from library module Graphic_image ******** *)
let array_of_image img =
  match img with
  | Index8 bitmap ->
      let w = bitmap.Index8.width
      and h = bitmap.Index8.height
      and colormap = bitmap.Index8.colormap.map in
      let cmap = Array.map (fun { r; g; b } -> rgb r g b) colormap in
      if bitmap.Index8.transparent <> -1 then
        cmap.(bitmap.Index8.transparent) <- transp;
      Array.init h (fun i ->
          Array.init w (fun j -> cmap.(Index8.unsafe_get bitmap j i)))
  | Index16 bitmap ->
      let w = bitmap.Index16.width
      and h = bitmap.Index16.height
      and colormap = bitmap.Index16.colormap.map in
      let cmap = Array.map (fun { r; g; b } -> rgb r g b) colormap in
      if bitmap.Index16.transparent <> -1 then
        cmap.(bitmap.Index16.transparent) <- transp;
      Array.init h (fun i ->
          Array.init w (fun j -> cmap.(Index16.unsafe_get bitmap j i)))
  | Rgb24 bitmap ->
      let w = bitmap.Rgb24.width and h = bitmap.Rgb24.height in
      Array.init h (fun i ->
          Array.init w (fun j ->
              let { r; g; b } = Rgb24.unsafe_get bitmap j i in
              rgb r g b))
  | Rgba32 _ | Cmyk32 _ -> failwith "RGBA and CMYK not supported"

let of_image img = Graphics.make_image (array_of_image img)

let draw_image img x y = Graphics.draw_image (of_image img) x y

let image_of grpimg =
  let rgb_of_color color =
    {
      r = (color lsr 16) land 255;
      g = (color lsr 8) land 255;
      b = color land 255;
    }
  in
  let array = Graphics.dump_image grpimg in
  let height = Array.length array in
  let width = Array.length array.(0) in
  let img = Rgb24.create width height in
  for y = 0 to height - 1 do
    for x = 0 to width - 1 do
      Rgb24.unsafe_set img x y (rgb_of_color array.(y).(x))
    done
  done;
  img

let get_image x y w h = image_of (Graphics.get_image x y w h)

(********************************************* ******** *)

(* let rec input f = try print_endline (let bkg = read_bkg f in
   description bkg (start_room adv)) with Sys_error s -> print_endline
   "\n\nFile doesn't exit, try a new file"; Stdlib.exit 0 *)
let tile_size = 40

let tile_number = 16

let draw_canvas () = Graphics.open_graph " 760x640"

let draw_bkg () =
  (* let () = Graphics.open_graph " 800x800" in *)
  let img = Png.load "tile_green_40.png" [] in
  let g = of_image img in
  for i = 0 to tile_number - 1 do
    for k = 0 to tile_number - 1 do
      Graphics.draw_image g ((tile_size * k) + 140) (tile_size * i)
    done
  done

let draw_obs1 ob =
  let img = Png.load "bush_40.png" [] in
  let g = of_image img in
  Graphics.draw_image g (fst ob + 140) (snd ob)

let draw_obs2 ob =
  let img = Png.load "stone_40.png" [] in
  let g = of_image img in
  Graphics.draw_image g (fst ob + 140) (snd ob)

let draw_board () =
  let img = Png.load "score_board_bkg.png" [] in
  let g = of_image img in
  Graphics.draw_image g 0 0

let draw_heart () =
  let img = Png.load "heart_26.png" [] in
  let g = of_image img in
  Graphics.draw_image g 30 40;
  Graphics.draw_image g 56 40;
  Graphics.draw_image g 82 40

let draw_head () =
  let img = Png.load "headshot_lama_100.png" [] in
  let g = of_image img in
  Graphics.draw_image g 20 520

let draw_all_obs bkg obs_num draw =
  let obs_lst = obs_num bkg in
  List.iter draw obs_lst

let draw_all_obs1 bkg = draw_all_obs bkg obs_one_xy draw_obs1

let draw_all_obs2 bkg = draw_all_obs bkg obs_two_xy draw_obs2

let draw_obs bkg =
  draw_all_obs1 bkg;
  draw_all_obs2 bkg

(* let init_p1_xy f = let bkg = read_bkg f in let st = init_state bkg
   (start_tile_one bkg) (start_tile_two bkg) in let player_1 =
   player_one st in curr_pos player_1 *)

let init_p1_xy f =
  let bkg = read_bkg f in
  let st = init_state bkg (start_tile_one bkg) in
  let player_1 = player_one st in
  curr_pos player_1

(*change *)
(* let init_p2_xy f = let bkg = read_bkg f in let st = init_state bkg
   (start_tile_two bkg) (start_tile_two bkg) in let player_2 =
   player_two st in curr_pos player_2 *)

(*change *)

(* let draw_plr1 p = let img = Png.load "p1_fontile.png" [] in let g =
   of_image img in let p1_xy = init_p1_xy p in Graphics.draw_image g
   (fst p1_xy) (snd p1_xy) *)

let draw_plr1 p1_xy =
  let img = Png.load "p1_40.png" [] in
  let g = of_image img in
  Graphics.draw_image g (fst p1_xy + 140) (snd p1_xy)

(* let draw_plr2 p2_xy = let img = Png.load "p1_40.png" [] in let g =
   of_image img in Graphics.draw_image g (fst p2_xy) (snd p2_xy) *)

let draw_state st =
  draw_obs (get_bkg st);
  draw_plr1 (curr_pos (player_one st))

(* draw_plr2 (curr_pos (player_two st)) *)

let draw_move st pos1 =
  let img = Png.load "tile_green_40.png" [] in
  let g = of_image img in
  Graphics.draw_image g (fst pos1 + 140) (snd pos1);
  draw_plr1 (curr_pos (player_one st))

let draw_tile x y =
  let img = Png.load "tile_green_40.png" [] in
  let g = of_image img in
  Graphics.draw_image g x y

let draw_explode x y =
  let img = Png.load "bomb_explode_40.png" [] in
  let g = of_image img in
  Graphics.draw_image g x y

let rec draw_tiles (pos_lst : (int * int) list) =
  match pos_lst with
  | [] -> ()
  | h :: t ->
      draw_tile (fst h + 140) (snd h);
      draw_tiles t

let draw_burnt_pl p1_xy =
  let img = Png.load "p1_b_40.png" [] in
  let g = of_image img in
  Graphics.draw_image g (fst p1_xy + 140) (snd p1_xy)

let rec draw_explodes (pos_lst : (int * int) list) =
  match pos_lst with
  | [] -> ()
  | h :: t ->
      draw_explode (fst h + 140) (snd h);
      draw_explodes t

let rec clean_bombs res b_lst =
  match b_lst with
  | [] -> res
  | h :: t ->
      clean_bombs (List.append (get_pos h :: get_neighbours h) res) t

let grids_to_clean pos_lst bkg =
  List.filter (fun x -> List.mem x (obs_two_xy bkg) = false) pos_lst

let draw_explosions b_lst bkg pl =
  let pos_lst = clean_bombs [] b_lst in
  let grids = grids_to_clean pos_lst bkg in
  draw_explodes grids;
  if in_blast_lst b_lst pl then draw_burnt_pl pl;
  Unix.sleepf 0.4;
  draw_tiles grids;
  draw_plr1 pl

let draw_bomb pl =
  let img = Png.load "bomb_40.png" [] in
  let g = of_image img in
  Graphics.draw_image g (fst pl + 140) (snd pl)

let draw_speedup x y =
  let img = Png.load "speedup_40.png" [] in
  let g = of_image img in
  Graphics.draw_image g x y

let rec draw_speedups (pos_lst : (int * int) list) =
  match pos_lst with
  | [] -> ()
  | h :: t ->
      draw_speedup (fst h + 140) (snd h);
      draw_speedups t

let clear_speedup2 st =
  let img = Png.load "tile_green_40.png" [] in
  let g = of_image img in
  let tool1_xy_lst = get_tool1_xys st in
  match tool1_xy_lst with
  | [] ->
      print_endline "tool list empty";
      ()
  | h :: t -> (
      print_endline "tool list not empty";
      let take_tool =
        List.filter
          (fun x -> tool_collision_gui x (player_one st))
          tool1_xy_lst
      in
      match take_tool with
      | [] -> print_endline "no collison"
      | h :: t ->
          print_endline "s collison";
          Graphics.draw_image g (fst h + 40) (snd h))

let clear_speedup st =
  let imgup = Png.load "tile_green_up.png" [] in
  let g_up = of_image imgup in
  let imgleft = Png.load "tile_green_left.png" [] in
  let g_left = of_image imgleft in
  let tool1_xy_lst = get_tool1_xys st in
  match tool1_xy_lst with
  | [] ->
      print_endline "tool list empty";
      ()
  | h :: t ->
      print_endline "tool list not empty";
      if tool_collision_gui h (player_one st) then
        print_endline "s collison"
      else ();
      if tool_collision_right_gui h (player_one st) then
        Graphics.draw_image g_left (fst h + 150) (snd h)
      else if tool_collision_left_gui h (player_one st) then
        Graphics.draw_image g_left (fst h + 140) (snd h)
      else if tool_collision_up_gui h (player_one st) then
        Graphics.draw_image g_up (fst h + 140) (snd h + 10)
      else if tool_collision_down_gui h (player_one st) then
        Graphics.draw_image g_up (fst h + 140) (snd h)

(* if tool_collision h (player_one st) then Graphics.draw_image g (fst
   h) (snd h) else () *)

(* let draw_move st pos1 pos2 = let img = Png.load "tile_green_40.png"
   [] in let g = of_image img in Graphics.draw_image g (fst pos1) (snd
   pos1); draw_plr1 (curr_pos (player_one st)); Graphics.draw_image g
   (fst pos2) (snd pos2); draw_plr2 (curr_pos (player_two st)) *)

(* let rec move st = let bkg = get_bkg st in let p = player_one st in
   match read_key () with | 'w' -> remember_mode false; draw_plr1
   (curr_pos (no_collision_up bkg p)) | 's' -> remember_mode false;
   draw_plr1 (curr_pos (move_down p)) | 'd' -> remember_mode false;
   draw_plr1 (curr_pos (move_right p)) | 'a' -> remember_mode false;
   draw_plr1 (curr_pos (move_left p)) | _ -> move st *)

(* let input f = try while true do let st = wait_next_event [
   Button_down; Key_pressed ] in auto_synchronize true; if st.button
   then raise Exit; if st.keypressed then print_endline "p"; move f done
   with Exit -> () *)

(* type obs = { mutable x : int; mutable y : int; }

   let obs1 = { x = 80; y = 80 }

   let obs2 = { x = 0; y = 80 } *)

(* let draw_obs1 p = let img = Png.load "ob1_80.png" [] in let g =
   of_image img in Graphics.draw_image g p.x p.y *)

(* let draw_obs2 p = let img = Png.load "ob3_80.png" [] in let g =
   of_image img in Graphics.draw_image g p.x p.y *)

(* ;; draw_obs1 obs1 *)

(* ;; draw_obs2 obs2 *)

(* type player = { mutable x : int; mutable y : int; }

   let player1 = { x = 0; y = 0 }

   let draw_player p = let img = Png.load "p1_fontile.png" [] in let g =
   of_image img in Graphics.draw_image g p.x p.y *)

(* let no_collision_up p (ob : obs) = p.x = ob.x && p.y + 80 != ob.y

   let no_collision_down p (ob : obs) = p.x = ob.x && p.y - 80 != ob.y

   let no_collision_right p (ob : obs) = p.y = ob.y && p.x + 80 != ob.x

   let no_collision_left p (ob : obs) = p.y = ob.y && p.x - 80 != ob.x *)

(* let player_moveup p (ob : obs) = if no_collision_up p ob then p.y <-
   p.y + 20; p

   let player_movedown p ob = if no_collision_down p ob then p.y <- p.y
   - 20; p

   let player_moveright p ob = if no_collision_right p ob then p.x <-
   p.x + 20; p

   let player_moveleft p ob = if no_collision_left p ob then p.x <- p.x
   - 20; p

   let move_up p (ob : obs) = draw_player (player_moveup p ob)

   let move_down p ob = draw_player (player_movedown p ob)

   let move_right p obs1 = draw_player (player_moveright p obs1)

   let move_left p obs1 = draw_player (player_moveleft p obs1)

   let rec move () p (ob : obs) = match read_key () with | 'w' ->
   remember_mode false; move_up p ob | 's' -> remember_mode false;
   move_down p ob | 'd' -> remember_mode false; move_right p ob | 'a' ->
   remember_mode false; move_left p ob | _ -> move () p ob

   ;; try while true do let st = wait_next_event [ Button_down;
   Key_pressed ] in auto_synchronize true; if st.button then raise Exit;
   if st.keypressed then print_endline "p"; move () player1 obs1 done
   with Exit -> () *)

(* print_endline a *)
(* Unix.sleep 10 *)

(* let draw_background = failwith "todo"

   let draw_player = failwith "todo"

   let draw_bomb = failwith "todo" *)
