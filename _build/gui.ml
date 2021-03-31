open Graphics
open Images

(* open Images.Png *)
(* open Images.Png *)
open Background
open Player
open State

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

let draw_canvas () = Graphics.open_graph " 800x800"

let draw_bkg () =
  (* let () = Graphics.open_graph " 800x800" in *)
  let img = Png.load "white.png" [] in
  let g = of_image img in
  for i = 0 to 9 do
    for k = 0 to 9 do
      Graphics.draw_image g (80 * k) (80 * i)
    done
  done

let draw_obs1 ob =
  let img = Png.load "ob1_80.png" [] in
  let g = of_image img in
  Graphics.draw_image g (fst ob) (snd ob)

let draw_obs2 ob =
  let img = Png.load "ob3_80.png" [] in
  let g = of_image img in
  Graphics.draw_image g (fst ob) (snd ob)

let draw_all_obs bkg obs_num draw =
  let obs_lst = obs_num bkg in
  List.iter draw obs_lst

let draw_all_obs1 bkg = draw_all_obs bkg obs_one_xy draw_obs1

let draw_all_obs2 bkg = draw_all_obs bkg obs_two_xy draw_obs2

let draw_obs bkg =
  draw_all_obs1 bkg;
  draw_all_obs2 bkg

let init_p1_xy f =
  let bkg = read_bkg f in
  let st = init_state bkg (start_tile_one bkg) in
  let player_1 = player_one st in
  curr_pos player_1

(* let draw_plr1 p = let img = Png.load "p1_fontile.png" [] in let g =
   of_image img in let p1_xy = init_p1_xy p in Graphics.draw_image g
   (fst p1_xy) (snd p1_xy) *)

let draw_plr p1_xy =
  let img = Png.load "p1_f.png" [] in
  let g = of_image img in
  Graphics.draw_image g (fst p1_xy) (snd p1_xy)

let draw_state st =
  draw_obs (get_bkg st);
  draw_plr (curr_pos (player_one st))

let draw_move st pos =
  let img = Png.load "white.png" [] in
  let g = of_image img in
  Graphics.draw_image g (fst pos) (snd pos);
  draw_plr (curr_pos (player_one st))

let rec move st =
  let bkg = get_bkg st in
  let p = player_one st in
  match read_key () with
  | 'w' ->
      remember_mode false;
      draw_plr (curr_pos (no_collision_up bkg p))
  | 's' ->
      remember_mode false;
      draw_plr (curr_pos (move_down p))
  | 'd' ->
      remember_mode false;
      draw_plr (curr_pos (move_right p))
  | 'a' ->
      remember_mode false;
      draw_plr (curr_pos (move_left p))
  | _ -> move st

let input f =
  try
    while true do
      let st = wait_next_event [ Button_down; Key_pressed ] in
      auto_synchronize true;
      if st.button then raise Exit;
      if st.keypressed then print_endline "p";
      move f
    done
  with Exit -> ()

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
