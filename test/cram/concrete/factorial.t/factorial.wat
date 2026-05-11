(module
  (func $print_i32 (import "ono" "print_i32") (param i32))
  (func $f (param $n i32) (result i32)

    (if
      (i32.eq
        (local.get $n)
        (i32.const 1))
      (then (return (local.get $n))))
    (return
      (i32.mul
        (call $f
          (i32.sub
            (local.get $n)
            (i32.const 1)))
        (local.get $n)
      )
    )
  )

  (func $main
    i32.const 5
    call $f
    call $print_i32
  )
  (start $main)
)
