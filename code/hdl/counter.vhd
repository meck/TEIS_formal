--------------------------------------------------------------------------------
-- File:             counter.vhd
--
-- Company:          Meck AB
-- Engineer:         Johan Eklund
-- Created:          01/16/21
--
-- Description:      Demo of formal verificaion for use
--                   with Symbiyos, Yosys, GHDL.
--------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

entity counter is
  generic (
    low_val  : natural := 0;
    high_val : natural := 16;
    formal   : boolean := true
  );
  port (
    clk       : in    std_logic;
    reset_n   : in    std_logic;
    enable    : in    std_logic;
    up        : in    std_logic;
    count_out : out   std_logic_vector(31 downto 0)
  );
end entity counter;

architecture rtl of counter is

  signal count : natural range low_val to high_val;

begin

  proc_count : process (clk, reset_n) is
  begin

    if (reset_n = '0') then
      count <= low_val;
    elsif (clk'event and clk = '1') then
      if (enable = '1') then
        if (up = '1' and count < high_val) then
          count <= count + 1;
        elsif (up = '0' and count > low_val) then
          count <= count - 1;
        end if;
      end if;
    end if;

  end process proc_count;

  count_out <= std_logic_vector(to_unsigned(count, count_out'length));

  formal_ver : if formal generate

  begin

    default clock is rising_edge(clk);

    -- Initial reset, >1 cycle low, >1 cycle high
    -- repeating
    initial_reset : assume {{not Reset_n[+]; Reset_n[+]}[+]};

    -- Valid range, output shall always be `low_val`
    -- and `high_val`.
    valid_range : assert always
      unsigned(count_out) >= to_unsigned(low_val,32) and
      unsigned(count_out) <= to_unsigned(high_val,32);

    -- Reset, output shall be initial value on reset and one cycle after
    reset_output : assert always
      reset_n = '0' |-> {(unsigned(count_out) = to_unsigned(low_val,32))[*2]};

    -- Output shall not change when enable low
    disable_stable : assert always
      not enable -> next (stable(count_out) until_ enable) abort not reset_n;

    -- Output shall stay saturated
    high_stable : assert always
      up and unsigned(count_out) = to_unsigned(high_val, 32) ->
      next stable(count_out) abort not reset_n;

    -- Output shall stay saturated
    low_stable : assert always
      not up and unsigned(count_out) = to_unsigned(low_val, 32) ->
        next stable(count_out) abort not reset_n;

    -- Increment
    count_up : assert always
        reset_n and up and enable and unsigned(count_out) < to_unsigned(high_val, 32) ->
          next unsigned(count_out) = unsigned(prev(count_out)) + 1
            abort not reset_n;

    -- Decrement
    count_down : assert always
        (reset_n and (up = '0')) and enable and unsigned(count_out) > to_unsigned(low_val, 32) ->
          next unsigned(count_out) = unsigned(prev(count_out)) - 1
            abort not reset_n;

    end generate formal_ver;

end architecture rtl;
