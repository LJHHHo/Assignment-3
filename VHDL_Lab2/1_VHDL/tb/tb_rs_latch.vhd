LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_rs_latch IS
END tb_rs_latch;

ARCHITECTURE sim OF tb_rs_latch IS
  SIGNAL s, r, q, qn : std_logic := '0';

  PROCEDURE check(SIGNAL sq, sqn : IN std_logic; eq, eqn : std_logic; msg : string) IS
  BEGIN
    ASSERT sq = eq AND sqn = eqn
      REPORT "FAIL " & msg & " : Q=" & std_logic'image(sq) & " QN=" & std_logic'image(sqn)
      SEVERITY error;
    REPORT "PASS " & msg & " : Q=" & std_logic'image(sq) & " QN=" & std_logic'image(sqn);
  END PROCEDURE;
BEGIN
  uut : ENTITY work.rs_latch PORT MAP (s => s, r => r, q => q, qn => qn);

  stim : PROCESS
  BEGIN
    s <= '0'; r <= '1'; WAIT FOR 10 ns; check(q, qn, '0', '1', "Reset      (S=0,R=1)");
    s <= '0'; r <= '0'; WAIT FOR 10 ns; check(q, qn, '0', '1', "Hold       (S=0,R=0)");
    s <= '1'; r <= '0'; WAIT FOR 10 ns; check(q, qn, '1', '0', "Set        (S=1,R=0)");
    s <= '0'; r <= '0'; WAIT FOR 10 ns; check(q, qn, '1', '0', "Hold       (S=0,R=0)");
    s <= '0'; r <= '1'; WAIT FOR 10 ns; check(q, qn, '0', '1', "Reset      (S=0,R=1)");
    s <= '1'; r <= '1'; WAIT FOR 10 ns; check(q, qn, '0', '0', "Forbidden  (S=1,R=1)");
    -- leaving 11 directly to 00 would make the NOR loop oscillate (race),
    -- so the forbidden state is left through a valid input
    s <= '1'; r <= '0'; WAIT FOR 10 ns; check(q, qn, '1', '0', "Set        (S=1,R=0)");
    s <= '0'; r <= '0'; WAIT FOR 10 ns; check(q, qn, '1', '0', "Hold       (S=0,R=0)");
    REPORT "RS latch simulation finished";
    WAIT;
  END PROCESS;
END sim;
