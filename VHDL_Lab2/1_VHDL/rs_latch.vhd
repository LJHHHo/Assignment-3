-------------------------------------------------------------------------------
-- 1. RS Latch (cross-coupled NOR gates)
--   S R | Q   QN  | function
--   0 0 | Q   QN  | Hold
--   1 0 | 1   0   | Set
--   0 1 | 0   1   | Reset
--   1 1 | 0   0   | Forbidden (Q = QN = 0, next state undefined after 11->00)
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY rs_latch IS
  PORT (
    s  : IN  std_logic;   -- Set
    r  : IN  std_logic;   -- Reset
    q  : OUT std_logic;
    qn : OUT std_logic
  );
END rs_latch;

ARCHITECTURE nor_gate OF rs_latch IS
  SIGNAL q_i  : std_logic;
  SIGNAL qn_i : std_logic;
BEGIN
  -- Two NOR gates with feedback, exactly as in the Logisim circuit
  q_i  <= r NOR qn_i;
  qn_i <= s NOR q_i;

  q  <= q_i;
  qn <= qn_i;
END nor_gate;
