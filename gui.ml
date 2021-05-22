open Graphics
open Images
open Background
open Player
open State
open Bomb
open ToolSpeedUp
open ToolAddHeart
open ToolAddBomb
open ToolTwoBomb

let read_bkg f = from_json (Yojson.Basic.from_file f)

(**************************************************************************
    From Libpng package[1], Graphics module[2], and CamlImages library[3].
    Reference:
    [1] https://opam.ocaml.org/packages/conf-libpng/
    [2] https://ocaml.org/releases/4.08/htmlman/libref/Graphics.html
    [3] https://opam.ocaml.org/packages/camlimages/
 **************************************************************************)
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

(**************************************************************************
      End Libpng package, Graphics module, and CamlImages library.
 **************************************************************************)

let tile_size = Background.tile_size

let tile_number = Background.tile_number

let draw_canvas () = Graphics.open_graph " 780x640"

let draw_file name pl =
  let img = Png.load name [] in
  let g = of_image img in
  Graphics.draw_image g (fst pl + 140) (snd pl)

let draw_file_no_displace name pl =
  let img = Png.load name [] in
  let g = of_image img in
  Graphics.draw_image g (fst pl) (snd pl)

let draw_score_cover xy = draw_file_no_displace "score_cover.png" xy

let draw_n xy n = draw_file_no_displace (string_of_int n ^ "_52.png") xy

let draw_score_pixel () =
  draw_file_no_displace "score_108.png" (253, 115)

let draw_num_pixel c xy =
  match c with
  | '0' -> draw_n xy 0
  | '1' -> draw_n xy 1
  | '2' -> draw_n xy 2
  | '3' -> draw_n xy 3
  | '4' -> draw_n xy 4
  | '5' -> draw_n xy 5
  | '6' -> draw_n xy 6
  | '7' -> draw_n xy 7
  | '8' -> draw_n xy 8
  | '9' -> draw_n xy 9
  | _ -> failwith "impossible"

let rec draw_score_str score_str x y =
  match score_str with
  | "" -> ()
  | score_str ->
      draw_num_pixel score_str.[0] (x, y);
      let rest_of_str =
        String.sub score_str 1 (String.length score_str - 1)
      in
      draw_score_str rest_of_str (x + 36) y

let rec draw_final_score st =
  draw_score_pixel ();
  let score = get_score st in
  let score_str = string_of_int score in
  draw_score_str score_str 361 150

let draw_start_screen () =
  let img = Png.load "start_screen.png" [] in
  let g = of_image img in
  Graphics.draw_image g 0 0

let draw_score st =
  draw_score_cover (45, 300);
  moveto 45 300;
  draw_string ("score: " ^ string_of_int (get_score st));
  set_text_size 20;
  moveto 45 300

let draw_choose_text () =
  draw_file_no_displace "choose_player.png" (135, 417)

let draw_lama () =
  draw_file_no_displace "headshot_lama_choose.png" (135, 207)

let draw_camel () =
  draw_file_no_displace "headshot_camel_choose.png" (456, 207)

let draw_instruction () =
  draw_file_no_displace "instruction_text_c.png" (0, 0);
  draw_file_no_displace "tool_speedup_60.png" (85, 348);
  draw_file_no_displace "tool_addheart_60.png" (85, 276);
  draw_file_no_displace "stone_60.png" (85, 207);
  draw_file_no_displace "bush_60.png" (85, 134);
  draw_file_no_displace "tool_addbomb_60.png" (401, 348);
  draw_file_no_displace "tool_twobomb_60.png" (401, 276);
  draw_file_no_displace "portal_60.png" (401, 207);
  draw_file_no_displace "enemy_60.png" (401, 134)

let draw_bkg () =
  let img = Png.load "tile_green_40.png" [] in
  let g = of_image img in
  for i = 0 to tile_number - 1 do
    for k = 0 to tile_number - 1 do
      Graphics.draw_image g ((tile_size * k) + 140) (tile_size * i)
    done
  done

let draw_obs1 ob = draw_file "bush_40.png" ob

let draw_obs2 ob = draw_file "stone_40.png" ob

let draw_obs3 ob = draw_file "portal.png" ob

let draw_board () = draw_file_no_displace "score_board_bkg.png" (0, 0)

let draw_head st =
  if st |> player_one |> get_plr_type = "caml" then
    draw_file_no_displace "headshot_camel.png" (20, 520)
  else draw_file_no_displace "headshot_lama_100.png" (20, 520)

let draw_win_image () = draw_file_no_displace "cong_324.png" (228, 201)

let draw_lose_image () = draw_file_no_displace "lose_324.png" (228, 201)

let draw_win st =
  draw_bkg ();
  draw_board ();
  draw_win_image ();
  draw_final_score st;
  Unix.sleepf 7.0;
  ()

let draw_lose st =
  draw_bkg ();
  draw_board ();
  draw_lose_image ();
  draw_final_score st;
  Unix.sleepf 7.0;
  ()

let draw_choose () =
  draw_bkg ();
  draw_board ();
  draw_choose_text ();
  draw_lama ();
  draw_camel ()

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

let init_p1_xy f plr_type =
  let bkg = read_bkg f in
  let st = init_state bkg (start_tile_one bkg) plr_type in
  let player_1 = player_one st in
  curr_pos player_1

let draw_tile xy = draw_file "tile_green_40.png" xy

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
      Graphics.draw_image g (x + 140) y;
      draw_tile (x, y)
  | None -> ()

let draw_plr1 st p1_xy =
  if st |> player_one |> get_plr_type = "caml" then
    draw_file "camel.png" p1_xy
  else draw_file "p1_40.png" p1_xy

let draw_state st =
  draw_obs (get_bkg st);
  draw_plr1 st (curr_pos (player_one st));
  draw_enemy (get_enemy_pos st)

let draw_move st pos_ply pos_enemy =
  draw_tile pos_ply;
  draw_plr1 st (curr_pos (player_one st));
  match pos_enemy with
  | Some pos_e ->
      draw_tile pos_e;
      draw_enemy (get_enemy_pos st)
  | None -> ()

let draw_explode x y = draw_file "bomb_explode_40.png" (x, y)

let rec draw_tiles (pos_lst : (int * int) list) =
  match pos_lst with
  | [] -> ()
  | h :: t ->
      draw_tile h;
      draw_tiles t

let draw_burnt_pl p1_xy = draw_file "p1_b_40.png" p1_xy

let rec draw_explodes (pos_lst : (int * int) list) =
  match pos_lst with
  | [] -> ()
  | h :: t ->
      draw_explode (fst h) (snd h);
      draw_explodes t

let rec clean_bombs res b_lst =
  match b_lst with
  | [] -> res
  | h :: t ->
      clean_bombs
        (List.append (get_pos h :: get_neighbours 1 h []) res)
        t

let tiles_to_clean pos_lst st =
  List.filter
    (fun x ->
      List.mem x (obs_two_xy (get_bkg st)) = false
      && List.mem x (obs_three_xy (get_bkg st)) = false
      && List.mem x (get_tool1_xys st) = false
      && List.mem x (get_tool2_xys st) = false)
    pos_lst

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

let in_blast_lst_op b_lst st =
  match get_enemy_pos st with
  | None -> false
  | Some xy -> in_blast_lst b_lst xy

let draw_explosions b_lst st (pl : Player.t) =
  let pos_lst = clean_bombs [] b_lst in
  let tiles = tiles_to_clean pos_lst st in
  draw_explodes tiles;
  if in_blast_lst b_lst (curr_pos pl) then draw_burnt_pl (curr_pos pl);
  if in_blast_lst_op b_lst st then draw_enemy_b (get_enemy_pos st);
  draw_heart_on_board pl;
  Unix.sleepf 0.4;
  draw_tiles tiles;
  draw_plr1 st (curr_pos pl)

let draw_bomb pl = draw_file "bomb_40.png" pl

let draw_left_panel st =
  draw_bkg ();
  draw_board ();
  draw_heart_3 ();
  draw_head st

let draw_speedup xy = draw_file "speedup_40.png" xy

let rec draw_speedups (pos_lst : (int * int) list) =
  match pos_lst with
  | [] -> ()
  | h :: t ->
      draw_speedup h;
      draw_speedups t

let draw_speedup xy = draw_file "speedup_40.png" xy

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

let draw_twobomb xy = draw_file "tool_twobomb.png" xy

let rec draw_twobombs (pos_lst : (int * int) list) =
  match pos_lst with
  | [] -> ()
  | h :: t ->
      draw_twobomb h;
      draw_twobombs t

let clear_tool f1 f2 st =
  match f1 st with
  | [] -> ()
  | h :: t -> (
      let to_r = tools_collision_gui_return (f2 st) (player_one st) in
      let to_r2 = tools_collision_return (f2 st) (player_one st) in
      let to_r3 = to_r <+> to_r2 in
      match to_r3 with
      | false, _ -> ()
      | true, h ->
          draw_tile h;
          draw_plr1 st (curr_pos (player_one st)))

let clear_speedup st = clear_tool get_tool1 get_tool1_xys st

let clear_addheart st = clear_tool get_tool2 get_tool2_xys st

let clear_addbomb st = clear_tool get_tool3 get_tool3_xys st

let clear_twobomb st = clear_tool get_tool4 get_tool4_xys st

let clear_tools st =
  clear_addheart st;
  clear_speedup st;
  clear_addbomb st;
  clear_twobomb st

let draw_tools st =
  draw_speedups (show_tools (exploding st) (get_bkg st) 1);
  draw_addhearts (show_tools (exploding st) (get_bkg st) 2);
  draw_addbombs (show_tools (exploding st) (get_bkg st) 3);
  draw_twobombs (show_tools (exploding st) (get_bkg st) 4)
