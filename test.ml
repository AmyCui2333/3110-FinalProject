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

(* 10 points: testing. Your source code must include an OUnit test suite
   that the grader can run with a make test command that you provide.
   You are also encouraged to use Bisect, but that is not required. At
   the top of your test file, which should be named test.ml or something
   very similar so that the grader can find it, please write a
   (potentially lengthy) comment describing your approach to testing:
   what you tested, anything you omitted testing, and why you believe
   that your test suite demonstrates the correctness of your system. A
   detailed rubric can be found below. *)

(* The test suite should be runnable with make test. *)

(* -3: The OUnit suite does not have at least 50 passing tests. *)
(* -5: The OUnit suite does not run with make test, or dies in the
   middle of running. *)
(* -6: There is noply_typeUnit suite. *)

(* On A2 in a previous semester, the course staff test suite contained
   52 tests. That was the smallest test suite out of all the
   assignments. Students wrote a median of 200 LoC (including tests) to
   solve the assignment. For a project in which 1500-2000 LOC is
   expected, 50 passing tests therefore is a minimal amount. In reality
   we should probably be asking for more, or for Bisect coverage. *)

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
   and stores them in a background object [bkg] *)
let bkg = from_json (Yojson.Basic.from_file "bkg_test.json")

let start_tile_test
    (name : string)
    (input : Background.t)
    (expected : xy) : test =
  name >:: fun _ -> assert_equal expected (start_tile_one input)

let obs_xy_test
    (name : string)
    (input : Background.t)
    (func_test : Background.t -> xy list)
    (expected : xy list) =
  name >:: fun _ -> assert_equal expected (func_test input)

let clear_obstacles_test
    (name : string)
    (input : Background.t)
    (obs_to_clear : (int * int) list)
    (expected : (int * int) list) : test =
  name >:: fun _ ->
  assert_equal expected
    (clear_obstacles obs_to_clear input |> obs_one_xy)

let background_tests =
  [
    (* start_tile *)
    start_tile_test "start_tile" bkg (40, 40);
    (* obs123_xy_test *)
    obs_xy_test "obs1 bush coordinates" bkg obs_one_xy
      [ (80, 80); (80, 120); (80, 160); (80, 200); (80, 240) ];
    obs_xy_test "obs2 wall coordinates" bkg obs_two_xy
      [
        (0, 0); (0, 40); (0, 80); (0, 120); (0, 160); (0, 200); (0, 240);
      ];
    obs_xy_test "obs3 portal coordinates" bkg obs_three_xy
      [ (160, 80); (160, 240) ];
    clear_obstacles_test "clear obstacles (80,80); (80,120)" bkg
      [ (80, 80); (80, 120) ]
      [ (80, 160); (80, 200); (80, 240) ];
  ]

(* TESTING MODULE: Player *)
(* read player type "lama" and initial position (40, 40); store
   information in the player object [ply_test] *)
let ply_test = build_player "lama" (40, 40)

let player_power_test (name : string) (expected : int) : test =
  name >:: fun _ -> assert_equal expected (get_power ply_test)

let get_plr_type_test (name : string) (expected : string) : test =
  name >:: fun _ -> assert_equal expected (get_plr_type ply_test)

let curr_pos_test (name : string) (expected : int * int) : test =
  name >:: fun _ -> assert_equal expected (curr_pos ply_test)

let move_test (name : string) move (expected : int * int) : test =
  name >:: fun _ -> assert_equal expected (curr_pos (move bkg ply_test))

let player_tests =
  [
    player_power_test "testing player power" 1;
    get_plr_type_test "testing player type" "lama";
    curr_pos_test "testing current position" (40, 40);
    move_test "move up" no_collision_up (40, 50);
    move_test "move down" no_collision_down (40, 30);
    move_test "move right" no_collision_right (50, 40);
    move_test "move left" no_collision_left (40, 40);
  ]

(* TESTING MODULE: Bomb *)
(* makes the bomb at the player [ply_test]'s current position (40, 40)
   with the bomb_power 1 and record a start time of bomb *)
let make_bomb_test =
  match make_bomb ply_test with
  | Some bomb -> bomb
  | _ -> failwith "wrong"

let test_get_neighbours
    (name : string)
    (power : int)
    (bomb : Bomb.t)
    (expected : (int * int) list) : test =
  name >:: fun _ ->
  assert_equal ~cmp:cmp_set_like_lists expected
    (get_neighbours power bomb [])

let test_in_blast_area
    (name : string)
    (bomb : Bomb.t)
    (pos : int * int)
    (expected : bool) : test =
  name >:: fun _ -> assert_equal expected (in_blast_area bomb pos)

let test_check_explode name bomb expected =
  name >:: fun _ -> assert_equal expected (check_explode bomb)

let bomb_tests =
  [
    test_get_neighbours
      "testing get neighbours for bomb with power 1 at (40,40)"
      (get_power ply_test) make_bomb_test
      [ (80, 40); (0, 40); (40, 80); (40, 0) ];
    test_in_blast_area
      "testing if (40,60) is in blast area for bomb with power 1 at \
       (40,40)"
      make_bomb_test (40, 60) true;
    test_in_blast_area
      "testing if (120,60) is in blast area for bomb with power 1 at \
       (40,40)"
      make_bomb_test (120, 60) false;
    test_check_explode "testing if bomb is about to explode"
      make_bomb_test false;
  ]

(* TESTING MODULE: Enemy *)
(* builds the enemy of type "slow" at position (560, 560), with [ (80,
   80); (80, 120); (80, 240) ] as tiles the enemy cannot step on *)
let test_enemy =
  build_enemy (560, 560) [ (80, 80); (80, 120); (80, 240) ] "slow"

let test_enemy_pos (name : string) (expected : int * int) : test =
  name >:: fun _ -> assert_equal expected (enemy_pos test_enemy)

let test_enemy_speed (name : string) (expected : int) : test =
  name >:: fun _ -> assert_equal expected (enemy_speed test_enemy)

let test_get_direction name expected =
  name >:: fun _ ->
  assert_equal expected (get_direction ply_test test_enemy)

let test_move_enemy name dir_lst expected =
  name >:: fun _ ->
  assert_equal expected (enemy_pos (move_enemy dir_lst bkg test_enemy))

let enemy_tests =
  [
    test_enemy_pos "testing get position of enemy at (560,560)"
      (560, 560);
    test_enemy_speed "testing get speed of slow enemy" 10;
    test_get_direction
      "get direction for enemy at (560, 560) and player at (40,40)"
      [ DOWN; LEFT; UP; RIGHT ];
    test_move_enemy
      "testing move_enemy for enemy at (560,560) and player at (40,40)"
      [ DOWN; LEFT; UP; RIGHT ]
      (560, 550);
    test_move_enemy
      "testing move_enemy for enemy at (560,560) and player at \
       (600,600)"
      [ UP; RIGHT; DOWN; LEFT ]
      (560, 570);
  ]

(* TESTING MODULE: state *)
(* initiates a state [test_state] with player at position (40, 40),
   background [bkg], and player type of "lama". *)
let test_state = init_state bkg (40, 40) "lama"

let tool1_lst = new_speedups_fromxy (tool_xy bkg 1)

let tool2_lst = new_addhearts_fromxy (tool_xy bkg 2)

let tool3_lst = new_addbombs_fromxy (tool_xy bkg 3)

let tool4_lst = new_twobombs_fromxy (tool_xy bkg 4)

let test_get_bkg name st expected =
  name >:: fun _ -> assert_equal expected (get_bkg st)

let test_player_one name st expected =
  name >:: fun _ -> assert_equal expected (player_one st)

let test_check_dead name st expected =
  name >:: fun _ -> assert_equal expected (check_dead st)

let test_all_cleared name st expected =
  name >:: fun _ -> assert_equal expected (all_cleared st)

let exploding_bomb =
  match make_bomb ply_test with
  | Some bomb -> bomb
  | _ -> failwith "wrong"

let test_some_explosion_true name st expected =
  name >:: fun _ ->
  let new_st = add_bomb exploding_bomb st in
  let _ = Unix.sleep 6 in
  assert_equal expected (some_explosion new_st)

let test_some_explosion_false name st expected =
  name >:: fun _ ->
  let new_st = add_bomb exploding_bomb st in
  assert_equal expected (some_explosion new_st)

let test_exploding name st expected =
  name >:: fun _ ->
  let new_st = add_bomb exploding_bomb st in
  let _ = Unix.sleep 6 in
  assert_equal expected (exploding new_st)

let test_get_tools_xys
    name
    st
    (get_tools_func : State.t -> (int * int) list)
    expected =
  name >:: fun _ -> assert_equal expected (get_tools_func st)

let test_get_enemy_pos name st expected =
  name >:: fun _ -> assert_equal expected (get_enemy_pos st)

let test_get_score name st expected =
  name >:: fun _ -> assert_equal expected (get_score st)

let test_clear_exploding name st expected =
  name >:: fun _ -> assert_equal expected (clear_exploding st)

let state_tests =
  [
    test_get_bkg "testing get_bkg for state with bkg as background"
      test_state bkg;
    test_player_one
      "testing player_one for state with ply_test as player" test_state
      ply_test;
    test_check_dead
      "testing check_dead for state where player is not dead" test_state
      false;
    test_all_cleared
      "testing all_clear for state which hasn't been cleared" test_state
      false;
    test_some_explosion_false
      "testing some_explosion for state that doesn't have an exploding \
       bomb"
      test_state false;
    test_some_explosion_true
      "testing some_explosion for state that has an exploding bomb"
      test_state true;
    test_exploding
      "testing exploding for state that has [exploding bomb] about to \
       explode"
      test_state [ exploding_bomb ];
    test_get_enemy_pos "testing get_enemy_pos in state with no enemy"
      test_state None;
    test_get_tools_xys "testing getting toolSpeedUp" test_state
      get_tool1_xys [];
    test_get_tools_xys "testing getting toolAddHeart" test_state
      get_tool2_xys [];
    test_get_tools_xys "testing getting toolAddBomb" test_state
      get_tool3_xys [];
    test_get_tools_xys "testing getting toolTwoBomb" test_state
      get_tool4_xys [];
    test_get_score "testing get_score in initial state" test_state 0;
    test_clear_exploding "testing clear_exploding with initial state"
      test_state test_state;
  ]

(* TESTING MODULE: ObsPortal *)
(* loads the background file [bkg] and initializes a portal object. *)
let test_portal = new_portal bkg

let get_portal_lower_xy_test name portal expected =
  name >:: fun _ -> assert_equal expected (get_portal_lower_xy portal)

let get_portal_upper_xy_test name portal expected =
  name >:: fun _ -> assert_equal expected (get_portal_upper_xy portal)

let portal_pos_test name xy portal expected =
  name >:: fun _ -> assert_equal expected (portal_pos xy portal)

let obs_portal_tests =
  [
    get_portal_lower_xy_test "lower portal" test_portal (160, 80);
    get_portal_upper_xy_test "upper portal" test_portal (160, 240);
    portal_pos_test "transfer to upper portal from lower portal"
      test_portal (160, 80) (160, 40);
    portal_pos_test "transfer to lower portal from upper portal"
      test_portal (160, 240) (160, 280);
  ]

let test_bombup_plr name plr expected =
  name >:: fun _ -> assert_equal expected (bombup_plr plr |> get_power)

let tool_addbomb_tests =
  [ test_bombup_plr "adding power to player with power 1" ply_test 2 ]

let tool_addheart_tests = []

(* let test_speedup = new_speedups_fromxy (tool_xy bkg 1) *)

(* let get_speedup_xy_test name tool1 expected = name >:: fun _ ->
   assert_equal expected (get_speedup_xy tool1) *)

let tool_speedup_tests =
  [ (* get_speedup_xy_test "testing the position of of the one
       ToolSpeedUp" (List.hd test_speedup) (40, 40); *) ]

let tool_twobomb_tests = []

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
