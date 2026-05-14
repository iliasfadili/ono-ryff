(module
  (func $i32_symbol (import "ono" "i32_symbol") (result i32))

  (func $is_bool (param $x i32) (result i32)
    (i32.or
      (i32.eq (local.get $x) (i32.const 0))
      (i32.eq (local.get $x) (i32.const 1)))
  )
  
  (func $main
    (local $c00 i32) (local $c01 i32) (local $c02 i32)
    (local $c10 i32) (local $c11 i32) (local $c12 i32)
    (local $c20 i32) (local $c21 i32) (local $c22 i32)
    (local $n i32)

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

    local.set $n

    local.get $n
    i32.const 3
    i32.eq

    local.get $c11
    i32.const 1
    i32.eq

    local.get $n
    i32.const 2
    i32.eq

    i32.and

    i32.or

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
