LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_dff_set_clr IS
END tb_dff_set_clr;

ARCHITECTURE sim OF tb_dff_set_clr IS
  SIGNAL clk, d, set, clr, q, qn : std_logic := '0';
  SIGNAL done : boolean := false;
  PROCEDURE check(SIGNAL sq : IN std_logic; eq : std_logic; msg : string) IS
  BEGIN
    ASSERT sq = eq REPORT "FAIL " & msg & " : Q=" & std_logic'image(sq) SEVERITY error;
    REPORT "PASS " & msg & " : Q=" & std_logic'image(sq);
  END PROCEDURE;
BEGIN
  uut : ENTITY work.dff_set_clr PORT MAP (clk => clk, d => d, set => set, clr => clr, q => q, qn => qn);

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
    -- 1) asynchronous clear in the middle of the clock-low phase
    d <= '1'; clr <= '1'; WAIT FOR 2 ns;  check(q, '0', "clr=1 -> Q=0 immediately (no clock edge)");  -- t=2
    clr <= '0';           WAIT FOR 10 ns; check(q, '1', "normal DFF: edge @10ns, D=1 -> Q=1");         -- t=12
    -- 2) asynchronous clear while clk = '1'
    clr <= '1';           WAIT FOR 2 ns;  check(q, '0', "clr=1 while clk=1 -> Q=0 immediately");      -- t=14
    clr <= '0';           WAIT FOR 4 ns;  check(q, '0', "clr released, no edge -> Q stays 0");       -- t=18
    -- 3) asynchronous set while clk = '0'
    d <= '0';             WAIT FOR 4 ns;                                                               -- t=22
    set <= '1';           WAIT FOR 2 ns;  check(q, '1', "set=1 -> Q=1 immediately (no clock edge)");  -- t=24
    -- set has to override the clock edge too (edge @30ns with D=0)
                          WAIT FOR 8 ns;  check(q, '1', "set=1 overrides edge with D=0 -> Q=1");      -- t=32
    -- 4) both active : clear has priority
    clr <= '1';           WAIT FOR 2 ns;  check(q, '0', "set=1 & clr=1 -> clear wins, Q=0");          -- t=34
    set <= '0';           WAIT FOR 2 ns;  check(q, '0', "clr=1 only -> Q=0");                          -- t=36
    clr <= '0'; d <= '1'; WAIT FOR 16 ns; check(q, '1', "normal DFF: edge @50ns, D=1 -> Q=1");         -- t=52
    d <= '0';             WAIT FOR 4 ns;  check(q, '1', "D=0 between edges -> hold 1");                -- t=56
                          WAIT FOR 16 ns; check(q, '0', "normal DFF: edge @70ns, D=0 -> Q=0");         -- t=72
    WAIT FOR 8 ns;
    done <= true;
    REPORT "DFF with async set/clear simulation finished";
    WAIT;
  END PROCESS;
END sim;
