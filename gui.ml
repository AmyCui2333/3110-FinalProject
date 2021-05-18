open Graphics
open Images

(* open Images.Png *)
(* open Images.Png *)
open Background
open Player
open State
open Bomb
open Tool_speedup
open Tool_addheart
open Tool_addbomb

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

let draw_canvas () = Graphics.open_graph " 780x640"

(* let set_pos = moveto 100 100 *)

let draw_file name pl =
  let img = Png.load name [] in
  let g = of_image img in
  Graphics.draw_image g (fst pl + 140) (snd pl)

let draw_score_cover xy = draw_file "score_cover.png" xy

let draw_score st =
  (* set_pos; *)
  draw_score_cover (45 - 140, 300);
  moveto 45 300;
  (* set_text_size 20; *)
  draw_string ("score: " ^ string_of_int (get_score st));
  set_text_size 20;
  moveto 45 300

let draw_bkg () =
  (* let () = Graphics.open_graph " 800x800" in *)
  let img = Png.load "tile_green_40.png" [] in
  let g = of_image img in
  for i = 0 to tile_number - 1 do
    for k = 0 to tile_number - 1 do
      Graphics.draw_image g ((tile_size * k) + 140) (tile_size * i)
    done
  done

let draw_obs1 ob = draw_file "bush_40.png" ob

(* let img = Png.load "bush_40.png" [] in let g = of_image img in
   Graphics.draw_image g (fst ob + 140) (snd ob) *)

let draw_obs2 ob = draw_file "stone_40.png" ob

(* let img = Png.load "stone_40.png" [] in let g = of_image img in
   Graphics.draw_image g (fst ob + 140) (snd ob) *)

let draw_obs3 ob = draw_file "portal.png" ob

let draw_board () =
  let img = Png.load "score_board_bkg.png" [] in
  let g = of_image img in
  Graphics.draw_image g 0 0

let draw_head () =
  let img = Png.load "headshot_lama_100.png" [] in
  let g = of_image img in
  Graphics.draw_image g 20 520

let draw_all_obs bkg obs_num draw =
  let obs_lst = obs_num bkg in
  List.iter draw obs_lst

let draw_all_obs1 bkg = draw_all_obs bkg obs_one_xy draw_obs1

let draw_all_obs2 bkg = draw_all_obs bkg obs_two_xy draw_obs2

let draw_all_obs3 bkg = draw_all_obs bkg obs_three_xy draw_obs3

let draw_obs bkg =
  draw_all_obs1 bkg;
  draw_all_obs2 bkg;
  draw_all_obs3 bkg

(* let init_p1_xy f = let bkg = read_bkg f in let st = init_state bkg
   (start_tile_one bkg) (start_tile_two bkg) in let player_1 =
   player_one st in curr_pos player_1 *)

let init_p1_xy f =
  let bkg = read_bkg f in
  let st = init_state bkg (start_tile_one bkg) in
  let player_1 = player_one st in
  curr_pos player_1

let draw_enemy pos =
  match pos with
  | Some (x, y) ->
      let img = Png.load "enemy.png" [] in
      let g = of_image img in
      Graphics.draw_image g (x + 140) y
  | None -> ()

let draw_enemy_b pos =
  match pos with
  | Some (x, y) ->
      let img = Png.load "enemy_b.png" [] in
      let g = of_image img in
      Graphics.draw_image g (x + 140) y
  | None -> ()

let draw_tile2 xy = draw_file "tile_green_40.png" xy

(* let img = Png.load "tile_green_40.png" [] in let g = of_image img in
   Graphics.draw_image g fstx y *)

(*change *)
(* let init_p2_xy f = let bkg = read_bkg f in let st = init_state bkg
   (start_tile_two bkg) (start_tile_two bkg) in let player_2 =
   player_two st in curr_pos player_2 *)

(*change *)

(* let draw_plr1 p = let img = Png.load "p1_fontile.png" [] in let g =
   of_image img in let p1_xy = init_p1_xy p in Graphics.draw_image g
   (fst p1_xy) (snd p1_xy) *)

let draw_plr1 p1_xy = draw_file "p1_40.png" p1_xy

(* let img = Png.load "p1_40.png" [] in let g = of_image img in
   Graphics.draw_image g (fst p1_xy + 140) (snd p1_xy) *)

(* let draw_plr2 p2_xy = let img = Png.load "p1_40.png" [] in let g =
   of_image img in Graphics.draw_image g (fst p2_xy) (snd p2_xy) *)

let draw_state st =
  draw_obs (get_bkg st);
  draw_plr1 (curr_pos (player_one st));
  draw_enemy (get_enemy_pos st)

(* draw_plr2 (curr_pos (player_two st)) *)

let draw_move st pos_ply pos_enemy =
  (* let img = Png.load "tile_green_40.png" [] in let g = of_image img
     in Graphics.draw_image g (fst pos1 + 140) (snd pos1); *)
  draw_tile2 pos_ply;
  draw_plr1 (curr_pos (player_one st));
  match pos_enemy with
  | Some pos_e ->
      draw_tile2 pos_e;
      draw_enemy (get_enemy_pos st)
  | None -> ()

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
      clean_bombs
        (List.append (get_pos h :: get_neighbours 1 h []) res)
        t

let grids_to_clean pos_lst st =
  List.filter
    (fun x ->
      List.mem x (obs_two_xy (get_bkg st)) = false
      && List.mem x (obs_three_xy (get_bkg st)) = false
      && List.mem x (get_tool1_xys st) = false
      && List.mem x (get_tool2_xys st) = false)
    pos_lst

(* let draw_explosions b_lst st pl = let pos_lst = clean_bombs [] b_lst
   in let grids = grids_to_clean pos_lst st in draw_explodes grids; if
   in_blast_lst b_lst (curr_pos pl) then draw_heart_on_board pl;
   Unix.sleepf 0.4; draw_tiles grids; draw_plr1 (curr_pos pl) *)

(* let draw_explosions b_lst st pl = let pos_lst = clean_bombs [] b_lst
   in let grids = grids_to_clean pos_lst st in draw_explodes grids; (*
   if in_blast_lst b_lst (curr_pos pl) then draw_burnt_minus_heart pl;
   *) if in_blast_lst b_lst (curr_pos pl) then draw_heart_on_board pl;
   Unix.sleepf 0.4; draw_tiles grids; draw_plr1 (curr_pos pl) *)

let draw_heart_3 () =
  let img_h = Png.load "heart_26.png" [] in
  let h = of_image img_h in
  Graphics.draw_image h 30 40;
  Graphics.draw_image h 56 40;
  Graphics.draw_image h 82 40

let draw_heart_2 () =
  let img_h = Png.load "heart_26.png" [] in
  let h = of_image img_h in
  let img_g = Png.load "tile_green_left.png" [] in
  let g = of_image img_g in
  Graphics.draw_image h 30 40;
  Graphics.draw_image h 56 40;
  Graphics.draw_image g 82 40

let draw_heart_1 () =
  let img_h = Png.load "heart_26.png" [] in
  let h = of_image img_h in
  let img_g = Png.load "tile_green_left.png" [] in
  let g = of_image img_g in
  Graphics.draw_image h 30 40;
  Graphics.draw_image g 56 40;
  Graphics.draw_image g 82 40

let draw_heart_0 () =
  let img_g = Png.load "tile_green_left.png" [] in
  let g = of_image img_g in
  Graphics.draw_image g 30 40;
  Graphics.draw_image g 56 40;
  Graphics.draw_image g 82 40

let draw_minus_heart b_lst p =
  if in_blast_lst b_lst (curr_pos p) && lives p == 2 then
    draw_heart_2 ()
  else if in_blast_lst b_lst (curr_pos p) && lives p == 1 then
    draw_heart_1 ()

let draw_heart_on_board pl =
  match lives pl with
  | 0 -> draw_heart_0 ()
  | 1 -> draw_heart_1 ()
  | 2 -> draw_heart_2 ()
  | 3 -> draw_heart_3 ()
  | _ -> failwith "impossible"

(* let draw_explosions b_lst st pl = let pos_lst = clean_bombs [] b_lst
   in let grids = grids_to_clean pos_lst st in draw_explodes grids; if
   in_blast_lst b_lst (curr_pos pl) then draw_heart_on_board pl;
   draw_burnt_pl (curr_pos pl); Unix.sleepf 0.4; draw_tiles grids;
   draw_plr1 (curr_pos pl) *)
let in_blast_lst_op b_lst st =
  match get_enemy_pos st with
  | None -> false
  | Some xy -> in_blast_lst b_lst xy

let draw_explosions b_lst st (pl : Player.t) =
  let pos_lst = clean_bombs [] b_lst in
  let grids = grids_to_clean pos_lst st in
  draw_explodes grids;
  if in_blast_lst b_lst (curr_pos pl) then draw_burnt_pl (curr_pos pl);
  if in_blast_lst_op b_lst st then draw_enemy_b (get_enemy_pos st);
  draw_heart_on_board pl;
  (* draw_minus_heart b_lst pl; *)
  Unix.sleepf 0.4;
  draw_tiles grids;
  draw_plr1 (curr_pos pl)

(* else if in_blast_lst_op b_lst bkg then *)

let draw_bomb pl = draw_file "bomb_40.png" pl

(* let img = Png.load "bomb_40.png" [] in let g = of_image img in
   Graphics.draw_image g (fst pl + 140) (snd pl) *)

let draw_speedup xy = draw_file "speedup_40.png" xy

(* let img = Png.load "speedup_40.png" [] in let g = of_image img in
   Graphics.draw_image g x y *)

let rec draw_speedups (pos_lst : (int * int) list) =
  match pos_lst with
  | [] -> ()
  | h :: t ->
      draw_speedup h;
      draw_speedups t

let draw_speedup xy = draw_file "speedup_40.png" xy

(* let img = Png.load "speedup_40.png" [] in let g = of_image img in
   Graphics.draw_image g x y *)

let rec draw_speedups (pos_lst : (int * int) list) =
  match pos_lst with
  | [] -> ()
  | h :: t ->
      draw_speedup h;
      draw_speedups t

let draw_addheart xy = draw_file "tool_addheart.png" xy

let rec draw_addhearts (pos_lst : (int * int) list) =
  match pos_lst with
  | [] -> ()
  | h :: t ->
      draw_addheart h;
      draw_addhearts t

let draw_addbomb xy = draw_file "tool_addbomb.png" xy

let rec draw_addbombs (pos_lst : (int * int) list) =
  match pos_lst with
  | [] -> ()
  | h :: t ->
      draw_addbomb h;
      draw_addbombs t

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

let clear_tool f1 f2 st =
  match f1 st with
  | [] -> ()
  | h :: t -> (
      let to_r = tools_collision_gui_return (f2 st) (player_one st) in
      (* print_endline (string_of_bool (fst to_r)); *)
      let to_r2 = tools_collision_return (f2 st) (player_one st) in
      (* print_endline (string_of_bool (fst to_r2)); *)
      let to_r3 = to_r <+> to_r2 in
      (* print_endline (string_of_bool (fst to_r3)); *)
      match to_r3 with
      | false, _ -> ()
      | true, h ->
          (* print_string (string_of_bool (fst to_r3)); *)
          draw_tile2 h;
          draw_plr1 (curr_pos (player_one st)))

let clear_speedup st = clear_tool get_tool1 get_tool1_xys st

let clear_addheart st = clear_tool get_tool2 get_tool2_xys st

let clear_addbomb st = clear_tool get_tool3 get_tool3_xys st

let clear_tools st =
  clear_addheart st;
  clear_speedup st;
  clear_addbomb st

let draw_tools st =
  draw_speedups (show_tool1s (exploding st) (get_bkg st));
  draw_addhearts (show_tool2s (exploding st) (get_bkg st));
  draw_addbombs (show_tool3s (exploding st) (get_bkg st))

(* if tool_collision_right_gui h (player_one st) then
   Graphics.draw_image g_left (fst h + 150) (snd h) else if
   tool_collision_left_gui h (player_one st) then Graphics.draw_image
   g_left (fst h + 140) (snd h) else if tool_collision_up_gui h
   (player_one st) then Graphics.draw_image g_up (fst h + 140) (snd h +
   10) else if tool_collision_down_gui h (player_one st) then
   Graphics.draw_image g_up (fst h + 140) (snd h)) *)

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
