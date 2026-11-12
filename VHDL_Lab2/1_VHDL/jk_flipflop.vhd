-------------------------------------------------------------------------------
-- 4. Positive-edge-triggered JK Flip-Flop
--   J K | Q(t+1) | function
--   0 0 | Q(t)   | Hold
--   0 1 | 0      | Reset
--   1 0 | 1      | Set
--   1 1 | not Q  | Toggle
-- clr : asynchronous clear (active high). Used to put the flip-flop into a
--       known state at power-up, the same as the CLR input of the gate-level
--       Logisim circuit (a JK flip-flop can never leave an unknown state by
--       itself because the next state depends on the current state).
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY jk_flipflop IS
  PORT (
    clk : IN  std_logic;
    clr : IN  std_logic;   -- asynchronous clear (active high)
    j   : IN  std_logic;
    k   : IN  std_logic;
    q   : OUT std_logic;
    qn  : OUT std_logic
  );
END jk_flipflop;

ARCHITECTURE bhv OF jk_flipflop IS
  SIGNAL q_i : std_logic;
BEGIN
  PROCESS (clk, clr)
  BEGIN
    IF clr = '1' THEN
      q_i <= '0';
    ELSIF rising_edge(clk) THEN
      IF    j = '0' AND k = '0' THEN q_i <= q_i;       -- Hold
      ELSIF j = '0' AND k = '1' THEN q_i <= '0';       -- Reset
      ELSIF j = '1' AND k = '0' THEN q_i <= '1';       -- Set
      ELSIF j = '1' AND k = '1' THEN q_i <= NOT q_i;   -- Toggle
      END IF;
    END IF;
  END PROCESS;

  q  <= q_i;
  qn <= NOT q_i;
END bhv;
