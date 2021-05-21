open Player
open Bomb
open Background

type t = {
  pos : int * int;
  pos2 : int * int;
}

let get_portal1_xy t = t.pos

let get_portal2_xy t = t.pos2

let new_portal bkg =
  {
    pos = List.hd (obs_three_xy bkg);
    pos2 = List.hd (List.rev (obs_three_xy bkg));
  }

let portal_pos xy t =
  match xy with
  | a, b when (a, b) = t.pos -> (a, b - 40)
  | a, b when (a, b) = t.pos2 -> (a, b + 40)
  | _ -> failwith "impossible"

let transfer_pl p new_pos = change_pl_pos p new_pos

(* let rec new_portal_fromxy xy_lst = match xy_lst with | [] -> [] | h
   :: t -> [ new_portal h ] @ new_portal_fromxy t *)

(* let show_tool3 port bkg = let tool3_list = tool3_xy bkg in let grids
   = get_neighbours 1 port [] in List.filter (fun x -> List.mem x grids)
   tool3_list

   let rec show_tool3s port_lst bkg = match port_lst with | [] -> [] | h
   :: t -> show_tool3 h bkg @ show_tool3s t bkg *)
