
library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

--  A testbench has no ports.

entity adder_tb is
end entity adder_tb;

architecture behav of adder_tb is

  constant c_sys_clk_period : time := 20 ns;

  signal done : boolean := false;

  component adder is
    port (
      clk     : in    std_logic;
      reset_n : in    std_logic;
      i0      : in    std_logic;
      i1      : in    std_logic;
      ci      : in    std_logic;
      s       : out   std_logic;
      co      : out   std_logic
    );
  end component;

  -- for adder_0: adder use entity work.adder;
  signal clk     : std_logic;
  signal reset_n : std_logic;
  signal i0      : std_logic;
  signal i1      : std_logic;
  signal ci      : std_logic;
  signal s       : std_logic;
  signal co      : std_logic;

begin

  --  Component instantiation.
  adder_0 : adder
    port map (
      clk     => clk,
      reset_n => reset_n,
      i0      => i0,
      i1      => i1,
      ci      => ci,
      s       => s,
      co      => co
    );

  -- Clock process
  proc_clock : process
  begin

    if done then
     wait; 
    end if;

    clk <= '0';
    wait for c_sys_clk_period / 2;
    clk <= '1';
    wait for c_sys_clk_period / 2;

  end process proc_clock;

  proc_reset : process
  begin

    reset_n <= '0';
    wait for c_sys_clk_period * 5;
    reset_n <= '1';
    wait;

  end process proc_reset;

  --  This process does the real job.
  process
    type pattern_type is record
      --  The inputs of the adder.
      i0, i1, ci : std_logic;
      --  The expected outputs of the adder.
      s, co : std_logic;
    end record;

    --  The patterns to apply.

      type pattern_array is array (natural range <>) of pattern_type;

        constant patterns : pattern_array :=
                                             (('0', '0', '0', '0', '0'),
                                             ('0', '0', '1', '1', '0'),
                                             ('0', '1', '0', '1', '0'),
                                             ('0', '1', '1', '0', '1'),
                                             ('1', '0', '0', '1', '0'),
                                             ('1', '0', '1', '0', '1'),
                                             ('1', '1', '0', '0', '1'),
                                             ('1', '1', '1', '1', '1'));

  begin

      -- wait for reset;
      wait for c_sys_clk_period * 8;

      --  Check each pattern.
      for i in patterns'range loop
        --  Set the inputs.
        i0 <= patterns(i).i0;
        i1 <= patterns(i).i1;
        ci <= patterns(i).ci;
        --  Wait for the results.
        wait for c_sys_clk_period;
        --  Check the outputs.
        assert s = patterns(i).s
          report "bad sum value" severity error;
        assert co = patterns(i).co
          report "bad carry out value" severity error;
        wait for c_sys_clk_period;
      end loop;
      assert false report "end of test" severity note;
      done <= true;
      wait;

  end process;

end architecture behav;
