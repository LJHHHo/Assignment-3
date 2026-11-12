-------------------------------------------------------------------------------
-- 2. D Latch with enable (level sensitive)
--   en = '1' : Q follows D (transparent)
--   en = '0' : Q holds its previous value
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY d_latch IS
  PORT (
    en : IN  std_logic;   -- enable
    d  : IN  std_logic;   -- data
    q  : OUT std_logic;
    qn : OUT std_logic
  );
END d_latch;

ARCHITECTURE bhv OF d_latch IS
  SIGNAL q_i : std_logic;
BEGIN
  PROCESS (en, d)
  BEGIN
    IF en = '1' THEN
      q_i <= d;
    END IF;            -- no ELSE: the value is held -> latch
  END PROCESS;

  q  <= q_i;
  qn <= NOT q_i;
END bhv;
