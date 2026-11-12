LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_jk_flipflop IS
END tb_jk_flipflop;

ARCHITECTURE sim OF tb_jk_flipflop IS
  SIGNAL clk, clr, j, k, q, qn : std_logic := '0';
  SIGNAL done : boolean := false;
  PROCEDURE check(SIGNAL sq : IN std_logic; eq : std_logic; msg : string) IS
  BEGIN
    ASSERT sq = eq REPORT "FAIL " & msg & " : Q=" & std_logic'image(sq) SEVERITY error;
    REPORT "PASS " & msg & " : Q=" & std_logic'image(sq);
  END PROCEDURE;
BEGIN
  uut : ENTITY work.jk_flipflop PORT MAP (clk => clk, clr => clr, j => j, k => k, q => q, qn => qn);

  clkgen : PROCESS
  BEGIN
    WHILE NOT done LOOP
      clk <= '0'; WAIT FOR 10 ns;
      clk <= '1'; WAIT FOR 10 ns;
    END LOOP;
    WAIT;
  END PROCESS;

  -- inputs change at the falling edge (t = 20n), edges at t = 20n+10
  stim : PROCESS
  BEGIN
    clr <= '1'; WAIT FOR 5 ns;  check(q, '0', "async clear -> Q=0");
    clr <= '0'; WAIT FOR 15 ns;                                  -- t=20
    j <= '1'; k <= '0'; WAIT FOR 12 ns; check(q, '1', "J=1 K=0 Set    -> Q=1");   -- edge 30
    j <= '0'; k <= '0'; WAIT FOR 20 ns; check(q, '1', "J=0 K=0 Hold   -> Q=1");   -- edge 50
    j <= '0'; k <= '1'; WAIT FOR 20 ns; check(q, '0', "J=0 K=1 Reset  -> Q=0");   -- edge 70
    j <= '0'; k <= '0'; WAIT FOR 20 ns; check(q, '0', "J=0 K=0 Hold   -> Q=0");   -- edge 90
    j <= '1'; k <= '1'; WAIT FOR 20 ns; check(q, '1', "J=1 K=1 Toggle -> Q=1");   -- edge 110
                        WAIT FOR 20 ns; check(q, '0', "J=1 K=1 Toggle -> Q=0");   -- edge 130
                        WAIT FOR 20 ns; check(q, '1', "J=1 K=1 Toggle -> Q=1");   -- edge 150
    j <= '0'; k <= '0'; WAIT FOR 8 ns;
    done <= true;
    REPORT "JK flip-flop simulation finished";
    WAIT;
  END PROCESS;
END sim;
