Generate a 3x3 configuration where the center cell is alive at the next step:
  $ ono symbolic center_alive_next.wat
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 0
    symbol symbol_1 i32 1
    symbol symbol_2 i32 0
    symbol symbol_3 i32 0
    symbol symbol_4 i32 1
    symbol symbol_5 i32 0
    symbol symbol_6 i32 1
    symbol symbol_7 i32 0
    symbol symbol_8 i32 0
  }
  breadcrumbs 1 1
  ono: [ERROR] owi error: Reached problem!
  [123]
Generate a 3x3 configuration where the center cell is born at the next step:
  $ ono symbolic center_birth_next.wat
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 1
    symbol symbol_1 i32 0
    symbol symbol_2 i32 1
    symbol symbol_3 i32 0
    symbol symbol_4 i32 0
    symbol symbol_5 i32 0
    symbol symbol_6 i32 0
    symbol symbol_7 i32 0
    symbol symbol_8 i32 1
  }
  breadcrumbs 1 1
  ono: [ERROR] owi error: Reached problem!
  [123]
