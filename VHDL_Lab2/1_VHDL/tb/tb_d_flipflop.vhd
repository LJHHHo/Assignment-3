LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_d_flipflop IS
END tb_d_flipflop;

ARCHITECTURE sim OF tb_d_flipflop IS
  SIGNAL clk, d, q, qn : std_logic := '0';
  SIGNAL done : boolean := false;
  PROCEDURE check(SIGNAL sq : IN std_logic; eq : std_logic; msg : string) IS
  BEGIN
    ASSERT sq = eq REPORT "FAIL " & msg & " : Q=" & std_logic'image(sq) SEVERITY error;
    REPORT "PASS " & msg & " : Q=" & std_logic'image(sq);
  END PROCEDURE;
BEGIN
  uut : ENTITY work.d_flipflop PORT MAP (clk => clk, d => d, q => q, qn => qn);

  -- 20 ns clock period, rising edges at 10, 30, 50, ...
  clkgen : PROCESS
  BEGIN
    WHILE NOT done LOOP
      clk <= '0'; WAIT FOR 10 ns;
      clk <= '1'; WAIT FOR 10 ns;
    END LOOP;
    WAIT;
  END PROCESS;

  stim : PROCESS
  BEGIN
    d <= '1'; WAIT FOR 12 ns;   check(q, '1', "rising edge @10ns, D=1 -> Q=1");      -- t=12
    d <= '0'; WAIT FOR 5 ns;    check(q, '1', "D=0 while clk=1 -> no change");       -- t=17
    WAIT FOR 6 ns;              check(q, '1', "D=0 while clk=0 -> no change");       -- t=23
    WAIT FOR 9 ns;              check(q, '0', "rising edge @30ns, D=0 -> Q=0");      -- t=32
    d <= '1'; WAIT FOR 4 ns;    check(q, '0', "D=1 while clk=1 -> no change");       -- t=36
    d <= '0'; WAIT FOR 6 ns;    -- t=42 (clk=0)
    d <= '1'; WAIT FOR 3 ns;    check(q, '0', "D pulse while clk=0 -> no change");   -- t=45
    d <= '0'; WAIT FOR 7 ns;    check(q, '0', "rising edge @50ns, D=0 -> Q=0");      -- t=52
    d <= '1'; WAIT FOR 20 ns;   check(q, '1', "rising edge @70ns, D=1 -> Q=1");      -- t=72
    WAIT FOR 8 ns;
    done <= true;
    REPORT "D flip-flop simulation finished";
    WAIT;
  END PROCESS;
END sim;
