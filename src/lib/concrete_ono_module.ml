type extern_func = Kdo.Concrete.Extern_func.extern_func

let buf = Buffer.create 2048

let steps = ref None

let generation = ref 0

let configure ~steps:s = 
  steps := s;
  generation := 0

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

let print_cell (n : Kdo.Concrete.I32.t) : (unit, _) Result.t =
  if (Kdo.Concrete.I32.to_int n) = 0 then (Buffer.add_string buf "[]") else (Buffer.add_string buf "🦊");
  Ok ()

let newline () : (unit, _) Result.t =
  Buffer.add_string buf "\n";
  Ok ()

let clear_screen () : (unit, _) Result.t =
  Buffer.add_string buf "--------------------|";
  Buffer.output_buffer stdout buf;
  print_newline ();
  Buffer.clear buf;
  incr generation;
  Ok ()

let init_random seed =
  match seed with
  | Some seed -> Random.init seed
  | None -> Random.self_init ()

let should_continue () : (Kdo.Concrete.I32.t, _) Result.t =
  let continue =
    match !steps with
    | None -> true
    | Some n -> !generation < n
  in
  Ok (Kdo.Concrete.I32.of_int (if continue then 1 else 0))

let m =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  let functions = [ ("print_i32", Extern_func (i32 ^->. unit, print_i32));
  ("print_i64", Extern_func (i64 ^->. unit, print_i64));
  ("random_i32", Extern_func (unit ^->. i32, random_i32));
  ("random_i32_under", Extern_func (i32 ^->. i32, random_i32_under));
  ("sleep", Extern_func (i32 ^->. unit, sleep));
  ("print_cell", Extern_func (i32 ^->. unit, print_cell));
  ("newline", Extern_func (unit ^->. unit, newline));
  ("clear_screen", Extern_func (unit ^->. unit, clear_screen));
  ("should_continue", Extern_func (unit ^->. i32, should_continue));  ] in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }
