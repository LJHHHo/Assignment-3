-------------------------------------------------------------------------------
-- 5. Positive-edge-triggered D Flip-Flop with asynchronous Set and Clear
--   clr = '1'             : Q <= '0' immediately (highest priority)
--   set = '1', clr = '0'  : Q <= '1' immediately
--   set = '0', clr = '0'  : normal D flip-flop (Q <= D at rising edge of clk)
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dff_set_clr IS
  PORT (
    clk : IN  std_logic;
    d   : IN  std_logic;
    set : IN  std_logic;   -- asynchronous set   (active high)
    clr : IN  std_logic;   -- asynchronous clear (active high, priority)
    q   : OUT std_logic;
    qn  : OUT std_logic
  );
END dff_set_clr;

ARCHITECTURE bhv OF dff_set_clr IS
  SIGNAL q_i : std_logic;
BEGIN
  -- clk, set and clr are all in the sensitivity list -> set/clr act
  -- without waiting for a clock edge (asynchronous)
  PROCESS (clk, set, clr)
  BEGIN
    IF clr = '1' THEN                -- 1st priority : Clear
      q_i <= '0';
    ELSIF set = '1' THEN             -- 2nd priority : Set
      q_i <= '1';
    ELSIF rising_edge(clk) THEN      -- otherwise    : normal D flip-flop
      q_i <= d;
    END IF;
  END PROCESS;

  q  <= q_i;
  qn <= NOT q_i;
END bhv;
