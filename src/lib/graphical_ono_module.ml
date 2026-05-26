type extern_func = Kdo.Concrete.Extern_func.extern_func

module R = Raylib

let cell_size = 50
let margin = 40
let window_width = 600
let window_height = 600

let window_ready = ref false

let current_row = ref []
let grid = ref []

let steps = ref None
let generation = ref 0
let display_last = ref None
let configure ~steps:s ~display_last:d =
  steps := s;
  display_last := d;
  generation := 0

let ensure_window_ready () =
  if not !window_ready then begin
    R.init_window window_width window_height "Graphical Ono Module";
    window_ready := true
  end;
  if R.window_should_close () then begin
    R.close_window ();
    exit 0
  end

let print_cell (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  let alive = Kdo.Concrete.I32.to_int n <> 0 in
  current_row := alive :: !current_row;
  Ok ()

let newline () : (unit, _) Result.t =
  grid := List.rev !current_row :: !grid;
  current_row := [];
  Ok ()

let clear_screen () : (unit, _) Result.t =
  ensure_window_ready ();

  R.begin_drawing ();
  R.clear_background R.Color.raywhite;

  List.iteri
    (fun row_idx row ->
      List.iteri
        (fun col_idx alive ->
          let x = margin + (col_idx * cell_size) in
          let y = margin + (row_idx * cell_size) in
          let color =
            if alive then R.Color.darkgray else R.Color.lightgray
          in
          R.draw_rectangle x y cell_size cell_size color;
          R.draw_rectangle_lines x y cell_size cell_size R.Color.gray)
        row)
    (List.rev !grid);

  R.end_drawing ();

  grid := [];
  current_row := [];

  Ok ()

let () = Random.self_init ()

let print_i32 (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let print_i64 (n : Kdo.Concrete.I64.t) : (unit, _) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let random_i32 () : (Kdo.Concrete.I32.t, _) Result.t =
  Ok (Kdo.Concrete.I32.of_int32 (Random.int32 Int32.max_int))

let random_i32_under (n : Kdo.Concrete.I32.t) : (Kdo.Concrete.I32.t, _) Result.t =
  Ok (Kdo.Concrete.I32.of_int (Random.int (Kdo.Concrete.I32.to_int n)))

let sleep (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  Unix.sleep (Kdo.Concrete.I32.to_int n);
  Ok ()

let should_continue () : (Kdo.Concrete.I32.t, _) Result.t =
  let continue =
    match !steps with
    | None -> true
    | Some n -> !generation < n
  in
  Ok (Kdo.Concrete.I32.of_int (if continue then 1 else 0))
  
let should_display () : (Kdo.Concrete.I32.t, _) Result.t =
  let display =
    match !steps, !display_last with
    | _, None -> true
    | None, Some _ -> true
    | Some total_steps, Some last ->
        !generation >= total_steps - last
  in
  Ok (Kdo.Concrete.I32.of_int (if display then 1 else 0))

let next_step () : (unit, _) Result.t =
  incr generation;
  Ok ()

let m =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  let functions =
    [ ("print_i32", Extern_func (i32 ^->. unit, print_i32))
    ; ("print_i64", Extern_func (i64 ^->. unit, print_i64))
    ; ("random_i32", Extern_func (unit ^->. i32, random_i32))
    ; ("random_i32_under", Extern_func (i32 ^->. i32, random_i32_under))
    ; ("sleep", Extern_func (i32 ^->. unit, sleep))
    ; ("print_cell", Extern_func (i32 ^->. unit, print_cell))
    ; ("newline", Extern_func (unit ^->. unit, newline))
    ; ("clear_screen", Extern_func (unit ^->. unit, clear_screen))
    ; ("should_continue", Extern_func (unit ^->. i32, should_continue))
    ; ("should_display", Extern_func (unit ^->. i32, should_display))
    ; ("next_step", Extern_func (unit ^->. unit, next_step))
    ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }