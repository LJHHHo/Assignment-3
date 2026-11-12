-------------------------------------------------------------------------------
-- 3. Positive-edge-triggered D Flip-Flop
--   Q takes the value of D only at the rising edge of clk.
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY d_flipflop IS
  PORT (
    clk : IN  std_logic;
    d   : IN  std_logic;
    q   : OUT std_logic;
    qn  : OUT std_logic
  );
END d_flipflop;

ARCHITECTURE bhv OF d_flipflop IS
  SIGNAL q_i : std_logic;
BEGIN
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      q_i <= d;
    END IF;
  END PROCESS;

  q  <= q_i;
  qn <= NOT q_i;
END bhv;
