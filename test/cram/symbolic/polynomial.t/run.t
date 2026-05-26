Test degree 3 avec 3 racines

  $ printf "1\n-7\n14\n-8\n" | ono symbolic polynomial.wat
  symbol_0
  symbol_1
  symbol_2
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 2
    symbol symbol_1 i32 1
    symbol symbol_2 i32 4
  }
  breadcrumbs 1
  ono: [ERROR] owi error: Reached problem!
  [123]

Test degree 2 polynomial avec 2 racines disctinctes

  $ printf "0\n1\n0\n-4\n" | ono symbolic polynomial.wat
  symbol_0
  symbol_1
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 2
    symbol symbol_1 i32 -2
  }
  breadcrumbs 1 1
  ono: [ERROR] owi error: Reached problem!
  [123]

Test degree 2 avec une double racine

  $ printf "0\n1\n-2\n1\n" | ono symbolic polynomial.wat
  symbol_0
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 1
    symbol symbol_1 i32 1
  }
  breadcrumbs 1 0
  ono: [ERROR] owi error: Reached problem!
  [123]

Test degree 1

  $ printf "0\n0\n2\n-8\n" | ono symbolic polynomial.wat
  symbol_0
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 4
  }
  breadcrumbs 1
  ono: [ERROR] owi error: Reached problem!
  [123]

Test polynomial sans racine 

  $ printf "0\n1\n0\n1\n" | ono symbolic polynomial.wat
  All OK!
  OK!
