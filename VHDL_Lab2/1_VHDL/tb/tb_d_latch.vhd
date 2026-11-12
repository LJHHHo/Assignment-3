LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_d_latch IS
END tb_d_latch;

ARCHITECTURE sim OF tb_d_latch IS
  SIGNAL en, d, q, qn : std_logic := '0';
  PROCEDURE check(SIGNAL sq : IN std_logic; eq : std_logic; msg : string) IS
  BEGIN
    ASSERT sq = eq REPORT "FAIL " & msg & " : Q=" & std_logic'image(sq) SEVERITY error;
    REPORT "PASS " & msg & " : Q=" & std_logic'image(sq);
  END PROCEDURE;
BEGIN
  uut : ENTITY work.d_latch PORT MAP (en => en, d => d, q => q, qn => qn);

  stim : PROCESS
  BEGIN
    en <= '1'; d <= '0'; WAIT FOR 10 ns; check(q, '0', "en=1 D=0 -> Q follows D");
    d <= '1';            WAIT FOR 10 ns; check(q, '1', "en=1 D=1 -> Q follows D");
    d <= '0';            WAIT FOR 5 ns;  check(q, '0', "en=1 D=0 -> Q follows D");
    d <= '1';            WAIT FOR 5 ns;  check(q, '1', "en=1 D=1 -> Q follows D");
    en <= '0';           WAIT FOR 5 ns;  check(q, '1', "en=0      -> hold 1");
    d <= '0';            WAIT FOR 10 ns; check(q, '1', "en=0 D=0 -> hold 1");
    d <= '1';            WAIT FOR 10 ns; check(q, '1', "en=0 D=1 -> hold 1");
    d <= '0';            WAIT FOR 5 ns;
    en <= '1';           WAIT FOR 10 ns; check(q, '0', "en=1 D=0 -> Q follows D");
    en <= '0';           WAIT FOR 5 ns;
    d <= '1';            WAIT FOR 10 ns; check(q, '0', "en=0 D=1 -> hold 0");
    en <= '1';           WAIT FOR 10 ns; check(q, '1', "en=1 D=1 -> Q follows D");
    REPORT "D latch simulation finished";
    WAIT;
  END PROCESS;
END sim;
