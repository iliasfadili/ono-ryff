(** Monadic bind operator for [('a, 'e) result].

    This operator allows chaining computations that may fail using the
    [let*] syntax extension. *)
let ( let* ) result f = Result.bind result f


(** Functor map operator for [('a, 'e) result].

    This operator applies a function to the successful value contained in a
    result while preserving possible errors. *)
let ( let+ ) result f = Result.map f result
