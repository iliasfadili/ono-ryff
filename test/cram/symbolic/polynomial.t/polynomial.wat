(module
  (func $i32_symbol (import "ono" "i32_symbol") (result i32))
  (func $read_i32 (import "ono" "read_i32") (result i32))
  (func $print_i32 (import "ono" "print_i32") (param i32))

  ;; P(x) = ax^3 + bx^2 + cx + d
  (func $poly
    (param $a i32) (param $b i32) (param $c i32) (param $d i32)
    (param $x i32)
    (result i32)

    (i32.add
      (i32.add
        (i32.mul
          (local.get $a)
          (i32.mul
            (i32.mul (local.get $x) (local.get $x))
            (local.get $x)))
        (i32.mul
          (local.get $b)
          (i32.mul (local.get $x) (local.get $x))))
      (i32.add
        (i32.mul (local.get $c) (local.get $x))
        (local.get $d)))
  )

  (func $is_root
    (param $a i32) (param $b i32) (param $c i32) (param $d i32)
    (param $x i32)
    (result i32)

    (i32.eq
      (call $poly
        (local.get $a) (local.get $b) (local.get $c) (local.get $d)
        (local.get $x))
      (i32.const 0))
  )

  ;;Aide avec l'ia pour essayer de corriger un bug.
  (func $in_bounds (param $x i32) (result i32)
    (i32.and
      (i32.ge_s (local.get $x) (i32.const -10000))
      (i32.le_s (local.get $x) (i32.const 10000)))
  )

  (func $solve_degree_1
    (param $a i32) (param $b i32) (param $c i32) (param $d i32)
    (local $x1 i32)

    (local.set $x1 (call $i32_symbol))

    (if
      (i32.and
        (call $in_bounds (local.get $x1))
        (call $is_root
          (local.get $a) (local.get $b) (local.get $c) (local.get $d)
          (local.get $x1)))
      (then
        (call $print_i32 (local.get $x1))
        unreachable
      )
    )
  )

  (func $solve_degree_2
  (param $a i32) (param $b i32) (param $c i32) (param $d i32)
  (local $x1 i32)
  (local $x2 i32)

  (local.set $x1 (call $i32_symbol))
  (local.set $x2 (call $i32_symbol))

  (if
    (i32.and
      (i32.and
        (call $in_bounds (local.get $x1))
        (call $in_bounds (local.get $x2)))
      (i32.and
        (call $is_root
          (local.get $a) (local.get $b) (local.get $c) (local.get $d)
          (local.get $x1))
        (call $is_root
          (local.get $a) (local.get $b) (local.get $c) (local.get $d)
          (local.get $x2))))
    (then
      (call $print_i32 (local.get $x1))

      (if
        (i32.ne (local.get $x1) (local.get $x2))
        (then
          (call $print_i32 (local.get $x2))
        )
      )

      unreachable
    )
  )
)

  (func $solve_degree_3
    (param $a i32) (param $b i32) (param $c i32) (param $d i32)
    (local $x1 i32)
    (local $x2 i32)
    (local $x3 i32)

    (local.set $x1 (call $i32_symbol))
    (local.set $x2 (call $i32_symbol))
    (local.set $x3 (call $i32_symbol))

    (if
      (i32.and
        (i32.and
          (i32.and
            (call $in_bounds (local.get $x1))
            (call $in_bounds (local.get $x2)))
          (call $in_bounds (local.get $x3)))
        (i32.and
          (i32.and
            (call $is_root
              (local.get $a) (local.get $b) (local.get $c) (local.get $d)
              (local.get $x1))
            (call $is_root
              (local.get $a) (local.get $b) (local.get $c) (local.get $d)
              (local.get $x2)))
          (i32.and
            (call $is_root
              (local.get $a) (local.get $b) (local.get $c) (local.get $d)
              (local.get $x3))
            (i32.and
              (i32.and
                (i32.ne (local.get $x1) (local.get $x2))
                (i32.ne (local.get $x1) (local.get $x3)))
              (i32.ne (local.get $x2) (local.get $x3))))))
      (then
        (call $print_i32 (local.get $x1))
        (call $print_i32 (local.get $x2))
        (call $print_i32 (local.get $x3))
        unreachable
      )
    )
  )

  (func $main
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (local $d i32)

    ;;lecture des coeff de l'utilisateur
    (local.set $a (call $read_i32))
    (local.set $b (call $read_i32))
    (local.set $c (call $read_i32))
    (local.set $d (call $read_i32))

    (if
      (local.get $a)
      (then
        (call $solve_degree_3
          (local.get $a) (local.get $b) (local.get $c) (local.get $d))
      )
      (else
        (if
          (local.get $b)
          (then
            (call $solve_degree_2
              (local.get $a) (local.get $b) (local.get $c) (local.get $d))
          )
          (else
            (if
              (local.get $c)
              (then
                (call $solve_degree_1
                  (local.get $a) (local.get $b) (local.get $c) (local.get $d))
              )
            )
          )
        )
      )
    )
  )

  (start $main)
)