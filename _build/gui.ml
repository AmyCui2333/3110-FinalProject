open Graphics
open Images 
(* open Graphic_image *)

let () = Graphics.open_graph " 1500x1500";;

let img = Png.load "C1_front.png" [];;
let g = Graphic_image.of_image img;;

Graphics.draw_image g 0 0;;

(* Unix.sleep 10;; *)