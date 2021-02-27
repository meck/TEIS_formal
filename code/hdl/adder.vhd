
library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

entity adder is
  generic (
    formal : boolean := true
  );
  port (
    clk     : in    std_logic;
    reset_n : in    std_logic;
    add_sub : in    std_logic;
    a,b     : in    std_logic_vector(3 downto 0);
    q       : in    std_logic_vector(4 downto 0)
  );
end entity adder;

architecture rtl of adder is

begin

  proc_add : process (clk, reset_n) is
  begin

    if (reset_n = '0') then
      q  <= (others => '0');
    elsif (rising_edge(clk)) then
      if add_sub = '1' then
        q <= 
      else

      end if;
      -- s  <= i0 xor i1 xor ci;
      -- co <= (i0 and i1) or (i0 and ci) or (i1 and ci);
    end if;

  end process proc_add;

  formalgen : if formal generate

    signal sum : natural;

    begin

    -- The current sum
    sum <= to_integer(unsigned'('0' & ci))
           + to_integer(unsigned'('0' & i0)) 
           + to_integer(unsigned'('0' & i1));

    default clock is rising_edge(clk);

    -- input series start in reset for 3
    -- cycles and run for 10 cycles
    -- input_val : restrict {{ (reset_n = '0')[* 3]; (reset_n = '1')[* 60]}[+]};

    -- reset output shall be low on reset
    -- and one cycle after
    -- reset_outputs : assert always {reset_n = '0' } |-> {(not s and not co)[* 2] };

    -- -- -- Sum high and low
    -- -- sum_high : assert always (sum > 1 and reset_n) -> next (s = '1') abort reset_n = '0';

    -- -- sum_high : assert always ((i0 xor i1 xor ci) and reset_n) -> next (s = '1') abort reset_n = '0';
    -- -- sum_low  : assert always not (i0 xor i1 xor ci) -> next (s = '0');

    -- sum_high : assert always ((sum mod 2) = 0)  -> next (s = '1') abort reset_n = '0';
    -- -- sum_low : assert always ((sum mod 2) = 0)  -> next (s = '0') abort reset_n = '0';
    -- -- sum_low  : assert always not (i0 xor i1 xor ci) -> next (s = '0');

    -- -- -- Carry out high and low
    -- carry_high : assert always (sum > 1 and reset_n) -> next (co = '1') abort reset_n = '0';
    -- carry_low : assert always (sum < 2 and reset_n) -> next (co = '0');

  end generate formalgen;

end architecture rtl;
