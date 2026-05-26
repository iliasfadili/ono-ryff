(* The `ono concrete` command. *)

open Cmdliner
open Ono_cli

let info = Cmd.info "concrete" ~exits

let use_graphical_window =
  let doc = "Use a graphical window instead of the terminal output." in
  Arg.(value & flag & info [ "use-graphical-window" ] ~doc)

let steps =
  let doc = "Run only N steps of the Game of Life." in
  Arg.(value & opt (some int)None & info ["steps"] ~docv:"N" ~doc)

let display_last =
  let doc = "Display only the last N steps of the Game of Life." in
  Arg.(value & opt (some int) None & info [ "display-last" ] ~docv:"N" ~doc)

let seed =
  let doc = "Seed used to initialize the random generator." in
  Arg.(value & opt (some int) None & info [ "seed" ] ~docv:"SEED" ~doc)

let term =
  let open Term.Syntax in
  let+ () = setup_log
  and+ use_graphical_window = use_graphical_window
  and+ seed = seed
  and+ steps = steps
  and+ display_last = display_last
  and+ source_file = source_file in
  let result =
    Ono.Concrete_driver.run
      ~use_graphical_window:use_graphical_window
      ~steps:steps
      ~display_last:display_last
      ~seed:seed
      ~source_file:source_file
  in
  match result with
  | Ok () -> Ok ()
  | Error e -> Error (`Msg (Kdo.R.err_to_string e))

let cmd : Ono_cli.outcome Cmd.t = Cmd.v info term


