library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

entity exp is
  port (
    clk_w : in    std_logic;
    clk_r : in    std_logic;

    data_in : in    std_logic_vector(3 downto 0);
    we      : in    std_logic;
    w_addr  : in    std_logic_vector(3 downto 0);

    data_out : out   std_logic_vector(3 downto 0);
    r_addr   : in    std_logic_vector(3 downto 0)
  );
end entity exp;

architecture behav of exp is

  subtype word_t is std_logic_vector(3 downto 0);

  type memory_t is array(15 downto 0) of word_t;

  signal ram : memory_t;

begin

  proc_w : process (clk_w) is
  begin

    if rising_edge(clk_w) then
      if (we = '1') then
        ram(to_integer(unsigned(w_addr))) <= data_in;
      end if;
    end if;

  end process proc_w;

  proc_r : process (clk_r) is
  begin

    if rising_edge(clk_r) then
      data_out <= ram(to_integer(unsigned(r_addr)));
    end if;

  end process proc_r;

end architecture behav;


