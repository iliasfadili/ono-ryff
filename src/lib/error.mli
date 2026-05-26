(** Error types shared by the Ono command-line interface.

    This module defines the errors that can be returned by the concrete or
    symbolic execution pipeline and translated into command-line exit codes. *)

type t =
  [ `Msg of string
  | `Call_stack_exhausted
  | `Conversion_to_integer
  | `Integer_divide_by_zero
  | `Integer_overflow
  | `Out_of_bounds_memory_access
  | `Unreachable ]
