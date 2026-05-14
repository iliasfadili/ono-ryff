Generate a 3x3 configuration where the center cell is alive at the next step:
  $ ono symbolic center_alive_next.wat 2>&1 | grep -E "Trap: unreachable|model"
  ono: [ERROR] Trap: unreachable
  model {

Generate a 3x3 configuration where the center cell is born at the next step:
  $ ono symbolic center_birth_next.wat 2>&1 | grep -E "Trap: unreachable|model"
  ono: [ERROR] Trap: unreachable
  model {

Generate a 3x3 configuration where the middle row is alive at the next step:
  $ ono symbolic row_middle_alive_next.wat 2>&1 | grep -E "Trap: unreachable|model"
  ono: [ERROR] Trap: unreachable
  model {

Generate a 3x3 oscillator with period 2:
  $ ono symbolic oscillator_period_2.wat 2>&1 | grep -E "Trap: unreachable|model"
  ono: [ERROR] Trap: unreachable
  model {
