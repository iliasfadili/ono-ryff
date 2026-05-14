(module
  (func $i32_symbol (import "ono" "i32_symbol") (result i32))

  (func $is_bool (param $x i32) (result i32)
    (i32.or
      (i32.eq (local.get $x) (i32.const 0))
      (i32.eq (local.get $x) (i32.const 1)))
  )
  
  (func $next_cell (param $cell i32) (param $n i32) (result i32)
    (i32.or
    (i32.eq (local.get $n) (i32.const 3))
      (i32.and
        (i32.eq (local.get $cell) (i32.const 1))
        (i32.eq (local.get $n) (i32.const 2))
      )
    )
  )
  (func $main
    ;; Grille initiale
    (local $c00 i32) (local $c01 i32) (local $c02 i32)
    (local $c10 i32) (local $c11 i32) (local $c12 i32)
    (local $c20 i32) (local $c21 i32) (local $c22 i32)

    ;; Voisins pour step 1
    (local $n00 i32) (local $n01 i32) (local $n02 i32)
    (local $n10 i32) (local $n11 i32) (local $n12 i32)
    (local $n20 i32) (local $n21 i32) (local $n22 i32)

    ;; Grille après 1 step
    (local $s00 i32) (local $s01 i32) (local $s02 i32)
    (local $s10 i32) (local $s11 i32) (local $s12 i32)
    (local $s20 i32) (local $s21 i32) (local $s22 i32)

    ;; Voisins pour step 2
    (local $m00 i32) (local $m01 i32) (local $m02 i32)
    (local $m10 i32) (local $m11 i32) (local $m12 i32)
    (local $m20 i32) (local $m21 i32) (local $m22 i32)

    ;; Grille après 2 steps
    (local $t00 i32) (local $t01 i32) (local $t02 i32)
    (local $t10 i32) (local $t11 i32) (local $t12 i32)
    (local $t20 i32) (local $t21 i32) (local $t22 i32)

    call $i32_symbol
    local.set $c00

    call $i32_symbol
    local.set $c01

    call $i32_symbol
    local.set $c02

    call $i32_symbol
    local.set $c10

    call $i32_symbol
    local.set $c11

    call $i32_symbol
    local.set $c12

    call $i32_symbol
    local.set $c20

    call $i32_symbol
    local.set $c21

    call $i32_symbol
    local.set $c22

    local.get $c00
    call $is_bool

    local.get $c01
    call $is_bool
    i32.and

    local.get $c02
    call $is_bool
    i32.and

    local.get $c10
    call $is_bool
    i32.and

    local.get $c11
    call $is_bool
    i32.and

    local.get $c12
    call $is_bool
    i32.and

    local.get $c20
    call $is_bool
    i32.and

    local.get $c21
    call $is_bool
    i32.and

    local.get $c22
    call $is_bool
    i32.and

    (if
      (then
      )
      (else
        return
      )
    )

    ;; s00
    local.get $c01
    local.get $c10
    i32.add

    local.get $c11
    i32.add

    local.set $n00

    local.get $c00
    local.get $n00
    call $next_cell
    local.set $s00

    ;; s02
    local.get $c01
    local.get $c11
    i32.add

    local.get $c12
    i32.add

    local.set $n02

    local.get $c02
    local.get $n02
    call $next_cell
    local.set $s02

    ;; s20
    local.get $c10
    local.get $c11
    i32.add

    local.get $c21
    i32.add

    local.set $n20

    local.get $c20
    local.get $n20
    call $next_cell
    local.set $s20

    ;; s22
    local.get $c11
    local.get $c12
    i32.add

    local.get $c21
    i32.add

    local.set $n22

    local.get $c22
    local.get $n22
    call $next_cell
    local.set $s22

    ;; s01
    local.get $c00
    local.get $c02
    i32.add

    local.get $c10
    i32.add

    local.get $c11
    i32.add

    local.get $c12
    i32.add

    local.set $n01

    local.get $c01
    local.get $n01
    call $next_cell
    local.set $s01


    ;; s10
    local.get $c00
    local.get $c01
    i32.add

    local.get $c11
    i32.add

    local.get $c20
    i32.add

    local.get $c21
    i32.add

    local.set $n10

    local.get $c10
    local.get $n10
    call $next_cell
    local.set $s10


    ;; s12
    local.get $c01
    local.get $c02
    i32.add

    local.get $c11
    i32.add

    local.get $c21
    i32.add

    local.get $c22
    i32.add

    local.set $n12

    local.get $c12
    local.get $n12
    call $next_cell
    local.set $s12


    ;; s21
    local.get $c10
    local.get $c11
    i32.add

    local.get $c12
    i32.add

    local.get $c20
    i32.add

    local.get $c22
    i32.add

    local.set $n21

    local.get $c21
    local.get $n21
    call $next_cell
    local.set $s21
    
    ;; s11
    local.get $c00
    local.get $c01
    i32.add

    local.get $c02
    i32.add

    local.get $c10
    i32.add

    local.get $c12
    i32.add

    local.get $c20
    i32.add

    local.get $c21
    i32.add

    local.get $c22
    i32.add

    local.set $n11
    
    local.get $c11
    local.get $n11
    call $next_cell
    local.set $s11 

    ;; t00
    local.get $s01
    local.get $s10
    i32.add

    local.get $s11
    i32.add

    local.set $m00

    local.get $s00
    local.get $m00
    call $next_cell
    local.set $t00


    ;; t02
    local.get $s01
    local.get $s11
    i32.add

    local.get $s12
    i32.add

    local.set $m02

    local.get $s02
    local.get $m02
    call $next_cell
    local.set $t02


    ;; t20
    local.get $s10
    local.get $s11
    i32.add

    local.get $s21
    i32.add

    local.set $m20

    local.get $s20
    local.get $m20
    call $next_cell
    local.set $t20


    ;; t22
    local.get $s11
    local.get $s12
    i32.add

    local.get $s21
    i32.add

    local.set $m22

    local.get $s22
    local.get $m22
    call $next_cell
    local.set $t22


    ;; t01
    local.get $s00
    local.get $s02
    i32.add

    local.get $s10
    i32.add

    local.get $s11
    i32.add

    local.get $s12
    i32.add

    local.set $m01

    local.get $s01
    local.get $m01
    call $next_cell
    local.set $t01


    ;; t10
    local.get $s00
    local.get $s01
    i32.add

    local.get $s11
    i32.add

    local.get $s20
    i32.add

    local.get $s21
    i32.add

    local.set $m10

    local.get $s10
    local.get $m10
    call $next_cell
    local.set $t10


    ;; t12
    local.get $s01
    local.get $s02
    i32.add

    local.get $s11
    i32.add

    local.get $s21
    i32.add

    local.get $s22
    i32.add

    local.set $m12

    local.get $s12
    local.get $m12
    call $next_cell
    local.set $t12


    ;; t21
    local.get $s10
    local.get $s11
    i32.add

    local.get $s12
    i32.add

    local.get $s20
    i32.add

    local.get $s22
    i32.add

    local.set $m21

    local.get $s21
    local.get $m21
    call $next_cell
    local.set $t21


    ;; t11
    local.get $s00
    local.get $s01
    i32.add

    local.get $s02
    i32.add

    local.get $s10
    i32.add

    local.get $s12
    i32.add

    local.get $s20
    i32.add

    local.get $s21
    i32.add

    local.get $s22
    i32.add

    local.set $m11

    local.get $s11
    local.get $m11
    call $next_cell
    local.set $t11

    ;; t == c
    local.get $t00
    local.get $c00
    i32.eq

    local.get $t01
    local.get $c01
    i32.eq
    i32.and

    local.get $t02
    local.get $c02
    i32.eq
    i32.and

    local.get $t10
    local.get $c10
    i32.eq
    i32.and

    local.get $t11
    local.get $c11
    i32.eq
    i32.and

    local.get $t12
    local.get $c12
    i32.eq
    i32.and

    local.get $t20
    local.get $c20
    i32.eq
    i32.and

    local.get $t21
    local.get $c21
    i32.eq
    i32.and

    local.get $t22
    local.get $c22
    i32.eq
    i32.and

    ;; s != c
    local.get $s00
    local.get $c00
    i32.ne

    local.get $s01
    local.get $c01
    i32.ne
    i32.or

    local.get $s02
    local.get $c02
    i32.ne
    i32.or

    local.get $s10
    local.get $c10
    i32.ne
    i32.or

    local.get $s11
    local.get $c11
    i32.ne
    i32.or

    local.get $s12
    local.get $c12
    i32.ne
    i32.or

    local.get $s20
    local.get $c20
    i32.ne
    i32.or

    local.get $s21
    local.get $c21
    i32.ne
    i32.or

    local.get $s22
    local.get $c22
    i32.ne
    i32.or

    ;; oscillateur période 2 = t == c ET s != c
    i32.and

    (if
      (then
        unreachable
      )
      (else
        return
      )
    )

    return
    
  )

  (start $main)
)
