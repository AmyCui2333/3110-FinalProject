open Graphics
open Images


(* open Images.Png *)

(* open Images.Png *)

(* open Background *)


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

let () = Graphics.open_graph " 800x800";;

let img = Png.load "tile80.png"[];;

let g = of_image img;;

for i = 0 to 9 do 
  for k = 0 to 9 do
Graphics.draw_image g (80*k) (80*i)
done
done;;


(* let img2 = Png.load "p1_f.png"[] ;;
let g2 = of_image img2;;

Graphics.draw_image g2 0 0;; *)

type obs ={
  mutable x : int;
  mutable y : int
}

let obs1 = {
  x = 80;
  y = 80
}
let obs2 = {
  x = 0;
  y = 80
}
let draw_obs1 p = 
  let img = Png.load "ob1_80.png"[] in
  let g = of_image img in
  Graphics.draw_image g p.x p.y;;

  let draw_obs2 p = 
    let img = Png.load "ob3_80.png"[] in
    let g = of_image img in
    Graphics.draw_image g p.x p.y;;

  draw_obs1 obs1;;
  draw_obs2 obs2;;

type player = {
  mutable x : int;
  mutable y : int
}

let player1 = {
  x = 0;
  y = 0
}

let no_collision_up p (ob : obs) = p.y != ob.y

let no_collision_down p (ob : obs) = p.y - 80 != ob.y

let no_collision_right p (ob : obs) = p.x + 80 != ob.x 

let no_collision_up p (ob : obs) = p.x - 80 != ob.x 
let player_moveup p (ob : obs) =
  if p.x mod 80 = 0 && no_collision_up p ob then
  p.y <- p.y + 20;
  p
let player_movedown p ob=
  if p.x mod 80 = 0 then
    p.y <- p.y - 20;
    p

let player_moveright p ob=
  if p.y mod 80 = 0 then
    p.x <- p.x + 20;
    p

let player_moveleft p ob=
  if p.y mod 80 = 0 then
  p.x <- p.x - 20;
  p

  let draw_player p = 
    let img = Png.load "p1_ontile.png"[] in
    let g = of_image img in
    Graphics.draw_image g p.x p.y
    
let move_up p (ob : obs)= draw_player (player_moveup p ob)
let move_down p ob= draw_player (player_movedown p ob)
let move_right p obs1= draw_player (player_moveright p obs1)
let move_left p obs1= draw_player (player_moveleft p obs1)

let rec move () p (ob : obs) = match read_key () with
|'w' -> remember_mode false; move_up p ob; 
|'s' ->remember_mode false; move_down p ob; 
|'d' -> remember_mode false; move_right p ob; 
|'a' ->  remember_mode false; move_left p ob; 
|_ -> move ()p ob;;

try
  while true do
    let st = wait_next_event [ Button_down; Key_pressed ] in
    auto_synchronize true;
    if st.button then raise Exit;
    if st.keypressed then  print_endline "p"; move () player1 obs1; 
  done
with Exit -> ()



(* print_endline a *)
(* Unix.sleep 10 *)

(* let draw_background = failwith "todo"

   let draw_player = failwith "todo"

   let draw_bomb = failwith "todo" *)
