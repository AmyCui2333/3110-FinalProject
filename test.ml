(* Test Plan *)

(* We conducted OUnit testing on the following modules: Player,
   Background, State, Bomb, Enemy, ObsPortal, ToolAddBomb, ToolAddHeart,
   ToolSpeedUp, and ToolTwoBomb. We did not test Main or Gui because
   most functions in it depended on visually observing the Gui or using
   keyboard inputs. Those functions were tested manually later on. Test
   cases were developed using mainly glass-box testing, as the size and
   complexity of our system called for a thorough testing method. In
   addition, a lot of functions call other helpers, and we wanted to
   make sure we test each part before moving on to the next. *)

(* We conducted OUnit testing on functions that were unrelated to the
   GUI, didn't need user input, and returned values that can be
   relatively easy to construct. For example, functions that returned
   ints, int lists, booleans, etc. were tested, while functions that
   returned an updated state were not. This is mostly because the module
   signature doesn't always give us insight into all the updates, but
   visual testing using the GUI actually reflects these changes more
   easily. We also omitted most functions that needed to take in
   Unix.time() as an argument or performed updates based on time,
   because auto testing these would take a long time. *)

(* We believe that this testing approach demonstrates the correctness of
   our system because the test cases covers a decent proportion of the
   basic functions used to put together our game. Our test cases cover
   every modules that represents an element/feature of the game, and
   such coverage ensures that all parts of our systems are correct.
   After using OUnit tests to cover functionalities that were essential
   to our system, we then manually tested the assembly of these
   functions, which was the actual game. (Functions that updated the
   game state over time and through keyboard inputs were tested
   vigorously using the GUI, where any bugs would be reflected
   immediately) Thus, we have reason to believe that our test cases are
   sufficient to prove that our system works correctly. *)

open OUnit2
open Background
open Player
open Bomb
open Enemy
open State
open ObsPortal
open ToolAddBomb
open ToolAddHeart
open ToolSpeedUp
open ToolTwoBomb

(********************************************************************
       Helper functions for testing lists are equal to those in A2.
       Reference:
       Professor Michael Clarkson (mrc26@cornell.edu) and
       CS 3110 course staff at Cornell University.
 ********************************************************************)

let cmp_set_like_lists lst1 lst2 =
  let uniq1 = List.sort_uniq compare lst1 in
  let uniq2 = List.sort_uniq compare lst2 in
  List.length lst1 = List.length uniq1
  && List.length lst2 = List.length uniq2
  && uniq1 = uniq2

(** [pp_string s] pretty-prints string [s]. *)
let pp_string s = "\"" ^ s ^ "\""

(** [pp_list pp_elt lst] pretty-prints list [lst], using [pp_elt] to
    pretty-print each element of [lst]. *)
let pp_list pp_elt lst =
  let pp_elts lst =
    let rec loop n acc = function
      | [] -> acc
      | [ h ] -> acc ^ pp_elt h
      | h1 :: (h2 :: t as t') ->
          if n = 100 then acc ^ "..." (* stop printing long list *)
          else loop (n + 1) (acc ^ pp_elt h1 ^ "; ") t'
    in
    loop 0 "" lst
  in
  "[" ^ pp_elts lst ^ "]"

(********************************************************************
               Ending helper functions for testing lists.
 ********************************************************************)

(* TESTING MODULE: Background *)
(* loads json files that contain information about obstacles and tiles
   and stores them in a background objects [bkg] and [bkg2].*)
let bkg = from_json (Yojson.Basic.from_file "bkg_test.json")

let bkg2 = from_json (Yojson.Basic.from_file "bkg_test2.json")

let start_tile_test
    (name : string)
    (background : Background.t)
    (expected : int * int) : test =
  name >:: fun _ -> assert_equal expected (start_tile_one background)

let obs_xy_test
    name
    background
    (func_test : Background.t -> xy list)
    (expected : (int * int) list) =
  name >:: fun _ -> assert_equal expected (func_test background)

let clear_obstacles_test
    name
    background
    (obs_to_clear : (int * int) list)
    (expected : (int * int) list) : test =
  name >:: fun _ ->
  assert_equal expected
    (clear_obstacles obs_to_clear background |> obs_one_xy)

let background_tests =
  [
    start_tile_test "start_tile" bkg (40, 40);
    start_tile_test "start_tile 2" bkg2 (320, 320);
    obs_xy_test "obs1 bush coordinates" bkg obs_one_xy
      [ (80, 80); (80, 120); (80, 160); (80, 200); (80, 240) ];
    obs_xy_test "obs1 bush coordinates 2" bkg2 obs_one_xy
      [
        (280, 280);
        (280, 360);
        (280, 320);
        (320, 280);
        (320, 360);
        (360, 320);
      ];
    obs_xy_test "obs2 wall coordinates" bkg obs_two_xy
      [
        (0, 0); (0, 40); (0, 80); (0, 120); (0, 160); (0, 200); (0, 240);
      ];
    obs_xy_test "obs2 wall coordinates 2" bkg2 obs_two_xy
      [ (360, 280); (360, 360) ];
    obs_xy_test "obs3 portal coordinates" bkg obs_three_xy
      [ (160, 80); (160, 240) ];
    obs_xy_test "obs3 portal coordinates 2" bkg2 obs_three_xy
      [ (320, 240); (320, 400) ];
    clear_obstacles_test "clear obstacles (80,80); (80,120)" bkg
      [ (80, 80); (80, 120) ]
      [ (80, 160); (80, 200); (80, 240) ];
    clear_obstacles_test "clear obstacles (280,280); (280,360)" bkg2
      [ (280, 280); (280, 360) ]
      [ (280, 320); (320, 280); (320, 360); (360, 320) ];
  ]

(* TESTING MODULE: Player *)
(* reads player type "lama" and initial position (40, 40); store
   information in the player object [ply_test]. *)
let ply_test = build_player "lama" (40, 40)

(* reads player type "lama" and initial position (320, 320); store
   information in the player object [ply_test_2]. *)
let ply_test_2 = build_player "camel" (320, 320)

let player_power_test name (player : Player.t) (expected : int) =
  name >:: fun _ -> assert_equal expected (get_power player)

let get_plr_type_test name player (expected : string) =
  name >:: fun _ -> assert_equal expected (get_plr_type player)

let curr_pos_test name player (expected : int * int) =
  name >:: fun _ -> assert_equal expected (curr_pos player)

let move_test name move_func background player (expected : int * int) =
  name >:: fun _ ->
  assert_equal expected (curr_pos (move_func background player))

let player_tests =
  [
    player_power_test "player power" ply_test 1;
    player_power_test "player power 2" ply_test_2 1;
    get_plr_type_test "player type" ply_test "lama";
    get_plr_type_test "player type 2" ply_test_2 "camel";
    curr_pos_test "current position" ply_test (40, 40);
    curr_pos_test "current position 2" ply_test_2 (320, 320);
    move_test "move up" no_collision_up bkg ply_test (40, 50);
    move_test "move up 2" no_collision_up bkg2 ply_test_2 (320, 320);
    move_test "move down" no_collision_down bkg ply_test (40, 30);
    move_test "move down 2" no_collision_down bkg2 ply_test_2 (320, 320);
    move_test "move right" no_collision_right bkg ply_test (50, 40);
    move_test "move right 2" no_collision_right bkg2 ply_test_2
      (320, 320);
    move_test "move left" no_collision_left bkg ply_test (40, 40);
    move_test "move left 2" no_collision_left bkg2 ply_test_2 (320, 320);
  ]

(* TESTING MODULE: Bomb *)
(* makes the bomb at the player [ply_test]'s current position (40, 40)
   with the bomb_power 1 and records a start time of bomb *)
let bomb_test =
  match make_bomb ply_test with
  | Some bomb -> bomb
  | _ -> failwith "wrong"

(* makes the bomb at the player [ply_test_2]'s current position (320,
   320) with the bomb_power 1 and records a start time of bomb *)
let bomb_test_2 =
  match make_bomb ply_test_2 with
  | Some bomb -> bomb
  | _ -> failwith "wrong"

let test_get_neighbours
    name
    (power : int)
    (bomb : Bomb.t)
    (expected : (int * int) list) =
  name >:: fun _ ->
  assert_equal ~cmp:cmp_set_like_lists expected
    (get_neighbours power bomb [])

let test_in_blast_area name bomb (pos : int * int) (expected : bool) =
  name >:: fun _ -> assert_equal expected (in_blast_area bomb pos)

let test_check_explode name bomb (expected : bool) =
  name >:: fun _ -> assert_equal expected (check_explode bomb)

let bomb_tests =
  [
    test_get_neighbours
      "get neighbours for bomb with power 1 at (40,40)"
      (get_power ply_test) bomb_test
      [ (80, 40); (0, 40); (40, 80); (40, 0) ];
    test_get_neighbours
      "get neighbours for bomb with power 1 at (320,320)"
      (get_power ply_test_2) bomb_test_2
      [ (360, 320); (280, 320); (320, 360); (320, 280) ];
    test_in_blast_area
      "if (40,60) is in blast area for bomb with power 1 at (40,40)"
      bomb_test (40, 60) true;
    test_in_blast_area
      "if (120,60) is in blast area for bomb with power 1 at (40,40)"
      bomb_test (120, 60) false;
    test_in_blast_area
      "if (260,320) is in blast area for bomb with power 1 at (320,320)"
      bomb_test_2 (260, 320) true;
    test_in_blast_area
      "if (240,320) is in blast area for bomb with power 1 at (320,320)"
      bomb_test_2 (240, 320) false;
    test_check_explode "if bomb is about to explode" bomb_test false;
    test_check_explode "if bomb is about to explode" bomb_test_2 false;
  ]

(* TESTING MODULE: Enemy *)
(* builds the enemy of type "slow" at position (560,560), with
   [(80,80);(80,120);(80,240)] as tiles the enemy cannot step on *)
let test_enemy =
  build_enemy (560, 560) [ (80, 80); (80, 120); (80, 240) ] "slow"

(* builds the enemy of type "fast" at position (40,40), with
   [(320,240);(320,400)] as tiles the enemy cannot step on *)
let test_enemy_2 =
  build_enemy (40, 40) [ (320, 240); (320, 400) ] "fast"

let test_enemy_pos name (enemy : Enemy.t) (expected : int * int) =
  name >:: fun _ -> assert_equal expected (enemy_pos enemy)

let test_enemy_speed name enemy (expected : int) =
  name >:: fun _ -> assert_equal expected (enemy_speed enemy)

let test_get_direction
    name
    enemy
    player
    (expected : Enemy.direction list) =
  name >:: fun _ -> assert_equal expected (get_direction player enemy)

let test_move_enemy
    name
    background
    enemy
    (dir_lst : Enemy.direction list)
    (expected : int * int) =
  name >:: fun _ ->
  assert_equal expected
    (enemy_pos (move_enemy dir_lst background enemy))

let enemy_tests =
  [
    test_enemy_pos "get position of enemy at (560,560)" test_enemy
      (560, 560);
    test_enemy_pos "get position of enemy at (40,40) 2" test_enemy_2
      (40, 40);
    test_enemy_speed "get speed of slow enemy" test_enemy 10;
    test_enemy_speed "get speed of fase enemy 2" test_enemy_2 20;
    test_get_direction
      "get direction for enemy at (560,560) and player at (40,40)"
      test_enemy ply_test
      [ DOWN; LEFT; UP; RIGHT ];
    test_get_direction
      "get direction for enemy at (40,40) and player at (320,320) 2"
      test_enemy_2 ply_test_2
      [ RIGHT; UP; LEFT; DOWN ];
    test_move_enemy
      "move_enemy for enemy at (560,560) and player at (40,40)" bkg
      test_enemy
      [ DOWN; LEFT; UP; RIGHT ]
      (560, 550);
    test_move_enemy
      "move_enemy for enemy at (560,560) and player at (600,600)" bkg
      test_enemy
      [ UP; RIGHT; DOWN; LEFT ]
      (560, 570);
    test_move_enemy
      "move_enemy for enemy at (40,40) and player at (320,320) 2" bkg2
      test_enemy_2
      [ RIGHT; UP; LEFT; DOWN ]
      (60, 40);
    test_move_enemy
      "move_enemy for enemy at (40,40) and player at (600,40) 2" bkg2
      test_enemy_2
      [ RIGHT; DOWN; LEFT; UP ]
      (60, 40);
  ]

(* TESTING MODULE: state *)
(* initializes a state [test_state] with player at position (40, 40),
   background [bkg], and player type of "lama". *)
let test_state = init_state bkg (40, 40) "lama"

let tool1_lst = new_speedups_fromxy (tool_xy bkg 1)

let tool2_lst = new_addhearts_fromxy (tool_xy bkg 2)

let tool3_lst = new_addbombs_fromxy (tool_xy bkg 3)

let tool4_lst = new_twobombs_fromxy (tool_xy bkg 4)

(* initializes a state [test_state_2] with player at position (320,
   320), background [bkg2], and player type of "camel". *)
let test_state_2 = init_state bkg2 (320, 320) "camel"

let tool1_lst_2 = new_speedups_fromxy (tool_xy bkg2 1)

let tool2_lst_2 = new_addhearts_fromxy (tool_xy bkg2 2)

let tool3_lst_2 = new_addbombs_fromxy (tool_xy bkg2 3)

let tool4_lst_2 = new_twobombs_fromxy (tool_xy bkg2 4)

(* ends state initialization *)

let test_get_bkg name (st : State.t) (expected : Background.t) =
  name >:: fun _ -> assert_equal expected (get_bkg st)

let test_player_one name st (expected : Player.t) =
  name >:: fun _ -> assert_equal expected (player_one st)

let test_check_dead name st (expected : bool) =
  name >:: fun _ -> assert_equal expected (check_dead st)

let test_all_cleared name st (expected : bool) =
  name >:: fun _ -> assert_equal expected (all_cleared st)

let exploding_bomb plr =
  match make_bomb plr with Some bomb -> bomb | _ -> failwith "wrong"

let test_some_explosion_false name st (expected : bool) =
  name >:: fun _ ->
  let new_st = add_bomb (exploding_bomb (player_one st)) st in
  assert_equal expected (some_explosion new_st)

let test_some_explosion_true name st (expected : bool) =
  name >:: fun _ ->
  let new_st = add_bomb (exploding_bomb (player_one st)) st in
  let _ = Unix.sleep 6 in
  assert_equal expected (some_explosion new_st)

let test_get_tools_xys
    name
    st
    (get_tools_func : State.t -> (int * int) list)
    (expected : (int * int) list) =
  name >:: fun _ -> assert_equal expected (get_tools_func st)

let test_get_enemy_pos name st (expected : (int * int) option) =
  name >:: fun _ -> assert_equal expected (get_enemy_pos st)

let test_get_score name st (expected : int) =
  name >:: fun _ -> assert_equal expected (get_score st)

let test_clear_exploding name st (expected : State.t) =
  name >:: fun _ -> assert_equal expected (clear_exploding st)

let state_tests =
  [
    test_get_bkg "get_bkg, bkg" test_state bkg;
    test_get_bkg "get_bkg, bkg2 2" test_state_2 bkg2;
    test_player_one "player_one, player ply_test" test_state ply_test;
    test_player_one "player_one, player ply_test_2 2" test_state_2
      ply_test_2;
    test_check_dead "check_dead, player not dead" test_state false;
    test_check_dead "check_dead, player not dead 2" test_state_2 false;
    test_all_cleared "all_clear, uncleared" test_state false;
    test_all_cleared "all_clear, uncleared 2" test_state_2 false;
    test_some_explosion_false "some_explosion, has no exploding bomb"
      test_state false;
    test_some_explosion_true "some_explosion, has exploding bomb"
      test_state true;
    test_some_explosion_false "some_explosion, has no exploding bomb 2"
      test_state_2 false;
    test_some_explosion_true "some_explosion, has exploding bomb 2"
      test_state_2 true;
    test_get_enemy_pos "get_enemy_pos, no enemy" test_state None;
    test_get_enemy_pos "get_enemy_pos, no enemy 2" test_state_2 None;
    test_get_score "get_score in initial state" test_state 0;
    test_get_score "get_score in initial state 2" test_state_2 0;
    test_clear_exploding "clear_exploding with initial state" test_state
      test_state;
    test_clear_exploding "clear_exploding with initial state 2"
      test_state_2 test_state_2;
  ]

(* TESTING MODULE: ObsPortal *)
(* loads the background file [bkg] and initializes a portal object. *)
let test_portal = new_portal bkg

(* loads the background file [bkg2] and initializes a portal object. *)
let test_portal_2 = new_portal bkg2

let get_portal_lower_xy_test
    name
    (portal : ObsPortal.t)
    (expected : int * int) =
  name >:: fun _ -> assert_equal expected (get_portal_lower_xy portal)

let get_portal_upper_xy_test name portal (expected : int * int) =
  name >:: fun _ -> assert_equal expected (get_portal_upper_xy portal)

let portal_pos_test name portal pos (expected : int * int) =
  name >:: fun _ -> assert_equal expected (portal_pos portal pos)

let obs_portal_tests =
  [
    get_portal_lower_xy_test "lower portal" test_portal (160, 80);
    get_portal_upper_xy_test "upper portal" test_portal (160, 240);
    portal_pos_test "transfer to upper portal from lower portal"
      test_portal (160, 80) (160, 40);
    portal_pos_test "transfer to lower portal from upper portal"
      test_portal (160, 240) (160, 280);
    get_portal_lower_xy_test "lower portal 2" test_portal_2 (320, 240);
    get_portal_upper_xy_test "upper portal 2" test_portal_2 (320, 400);
    portal_pos_test "transfer to upper portal from lower portal 2"
      test_portal_2 (320, 240) (320, 200);
    portal_pos_test "transfer to lower portal from upper portal 2"
      test_portal_2 (320, 400) (320, 440);
  ]

(* let test_speedup = new_speedups_fromxy (tool_xy bkg 1) *)

(* let get_speedup_xy_test name tool1 expected = name >:: fun _ ->
   assert_equal expected (get_speedup_xy tool1) *)

let tool_speedup_tests =
  [
    test_get_tools_xys "getting toolSpeedUp" test_state get_tool1_xys [];
    test_get_tools_xys "getting toolSpeedUp 2" test_state_2
      get_tool1_xys [];
    (* get_speedup_xy_test "the position of of the one ToolSpeedUp"
       (List.hd test_speedup) (40, 40); *)
  ]

let tool_addheart_tests =
  [
    test_get_tools_xys "getting toolAddHeart" test_state get_tool2_xys
      [];
    test_get_tools_xys "getting toolAddHeart 2" test_state_2
      get_tool2_xys [];
  ]

let test_bombup_plr name plr expected =
  name >:: fun _ -> assert_equal expected (bombup_plr plr |> get_power)

let tool_addbomb_tests =
  [
    test_get_tools_xys "getting toolAddBomb" test_state get_tool3_xys [];
    test_get_tools_xys "getting toolAddBomb 2" test_state_2
      get_tool3_xys [];
    test_bombup_plr "adding power to player with power 1" ply_test 2;
    test_bombup_plr "adding power to player with power 1 2" ply_test_2 2;
  ]

let tool_twobomb_tests =
  [
    test_get_tools_xys "getting toolTwoBomb" test_state get_tool4_xys [];
    test_get_tools_xys "getting toolTwoBomb 2" test_state_2
      get_tool4_xys [];
  ]

let suite =
  "test suite"
  >::: List.flatten
         [
           background_tests;
           player_tests;
           bomb_tests;
           enemy_tests;
           state_tests;
           obs_portal_tests;
           tool_addbomb_tests;
           tool_addheart_tests;
           tool_speedup_tests;
           tool_twobomb_tests;
         ]

let _ = run_test_tt_main suite
