(** Concrete execution driver for Ono.

    This module is responsible for the full concrete execution pipeline:
    parsing a WebAssembly text file, compiling it to Wasm, validating it,
    linking it with the host [ono] module, and interpreting it. *)
open Syntax
module Interpret = Kdo.Interpret.Concrete (Kdo.Interpret.Default_parameters)

(** Run a WebAssembly module in concrete mode.

    [run ~use_graphical_window ~seed ~steps ~display_last ~source_file]
    loads [source_file], links it with the concrete host functions, and
    executes it.

    If [use_graphical_window] is [true], the graphical host module is used.
    Otherwise, the terminal-based host module is used.

    [seed] controls the random generator used by host functions.
    [steps], when provided, limits the number of Game of Life iterations.
    [display_last], when provided, displays only the last configurations. *)
    
let run ~use_graphical_window ~seed ~steps ~display_last ~source_file =
  Concrete_ono_module.init_random seed;
  (* Parsing. *)
  Logs.info (fun m -> m "Parsing file %a..." Fpath.pp source_file);
  let* wat_module = Kdo.Parse.Wat.Module.from_file source_file in
  Logs.debug (fun m ->
      m "Parsed module is:  @\n@[<v>%a@]" Kdo.Wat.Module.pp wat_module);

  (* Compiling to Wasm. *)
  Logs.info (fun m -> m "Compiling to Wasm...");
  let* wasm_module = Kdo.Compile.Wat.until_wasm ~unsafe:false wat_module in
  Logs.debug (fun m ->
      m "Compiled module is:  @\n@[<v>%a@]" Kdo.Wasm.Module.pp wasm_module);

  (* Validation step. *)
  Logs.info (fun m -> m "Validating...");
  let* () = Kdo.Validate.Wasm.modul wasm_module in

  (* Linking. *)
  Logs.info (fun m -> m "Linking...");
  let link_state : Kdo.Concrete.Extern_func.extern_func Kdo.Link.State.t =
    Kdo.Link.State.empty ()
  in
  let ono_module =
    if use_graphical_window then begin
      Graphical_ono_module.configure ~steps ~display_last;
      Graphical_ono_module.m
    end
    else begin
      Concrete_ono_module.configure ~steps ~display_last;
      Concrete_ono_module.m
    end
  in
  let link_state =
    Kdo.Link.Extern.modul ono_module link_state ~name:"ono"
  in
  let name = Some (Fpath.to_string source_file) in
  let* linked_module, link_state =
    Kdo.Link.Wasm.modul link_state ~name wasm_module
  in

  (* Interpreting. *)
  Logs.info (fun m -> m "Interpreting...");
  Interpret.modul link_state linked_module
