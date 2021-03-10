--------------------------------------------------------------------
-- Company:      TEIS AB
-- Engineer:     TEIS
--
-- Create Date:  2012-10-28
-- Design Name:  simple_VHDL_CPU - part of CPU_VHDL_projekt
-- Target Devices:ALTERA Cyclone IV EP4CE115F29C7
-- Tool versions:  Quartus v12 and ModelSim
-- Testbench file:simulation/modelsim/CPU_VHDL_projekt.vht
-- Do file:      simulation/modelsim/CPU_VHDL_projekt_run_msim_rtl_vhdl.do
--
-- Description:
--    TEIS CPU
--    8 bit Program Counter - Reset at 0
--    8 bit Data Address
--    16 bit register (R0)
--
--    Instruction Set
--
--  NOP      Opcode = 0x0000    Clocks:  4
--  LOAD     Opcode = 0x1       Clocks:  4
--  STORE    Opcode = 0x2       Clocks:  5
--  JMP      Opcode = 0x3       Clocks:  4
--
-- INSTRUCTION EXECUTION
--
--  Each instruction will take 4 or 5 clock cycles
--  Instruction fetch will take 3 clocks, and execution 1 or 2 clocks.
--
--  Instruction state 1
--    PC address is emitted
--  Instruction state 2
--    Wait state
--  Instruction state 3
--    Instruction read, PC incremented
--  Decode/Execution 1
--
--    NOP    No Operation
--    LOAD_R0  R0 loaded from IMM(11:0)
--    JMP    PC loaded from IMM(11:0)
--    STORE_R0  Address loaded from IMM(11:0)
--        Data driven by R0
--  Decode/Execution 2
--
--    STORE_R0  Strobes deasserted, to provide hold time
--
-- Inputs
--  Clk_50    System Clock
--  reset_n    Asynchronous Reset
--  data_bus_in  16 bit Instruction Data Bus
--      We do not support reading data (yet)
-- Outputs
--  WE_n    Write Enable
--  RD_n    Read Enable
--  bus_en_n
--  data_bus_out  16 bit Data Bus out for LEDs
--  Addr_bus  8 bit Address Bus
--------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity simple_vhdl_cpu is                                  -- very simple CPU
    port (
        clk_50       : in    std_logic;
        reset_n      : in    std_logic;
        we_n         : out   std_logic;
        rd_n         : out   std_logic;
        bus_en_n     : out   std_logic;
        data_bus_out : out   std_logic_vector(15 downto 0);
        data_bus_in  : in    std_logic_vector(15 downto 0);
        addr_bus     : out   std_logic_vector(7 downto 0);
        pc           : out   std_logic_vector(7 downto 0); -- to display Instruction adress, Next instruction to execute
        ir_out       : out   std_logic_vector(7 downto 0); -- to display
        cpu_state    : out   std_logic_vector(1 downto 0)  -- to display
    );
end entity simple_vhdl_cpu;

architecture rtl of simple_vhdl_cpu is

    -- Build an enumerated type for the state machine

    type state_type is (
        Fetch_1_state, Fetch_2_state, Fetch_3_state, Decode_state, Execute_NOP_state, Execute_JMP_state,
        Execute_LOAD_state, Execute_STORE_state, STORE_1_state, STORE_2_state
    );

    -- Register to hold the current state
    signal next_state : state_type;

    --  Opcodes for the implemented instruction
    constant nop   : std_logic_vector(3 downto 0) := "0000";
    constant load  : std_logic_vector(3 downto 0) := "0001";
    constant store : std_logic_vector(3 downto 0) := "0010";
    constant jmp   : std_logic_vector(3 downto 0) := "0011";

    --  CPU registers
    signal pc_reg    : unsigned(7 downto 0);          -- Program pointer, Next instruction to execute
    signal ir        : std_logic_vector(15 downto 0); -- Instruction register
    signal cpu_reg_0 : std_logic_vector(15 downto 0); -- CPU data register

begin

    PC                 <= std_logic_vector(pc_reg);
    IR_out(7 downto 0) <= ("0000" & ir(15 downto 12)); -- patch

    process (reset_n, clk_50) is
    begin

        if (reset_n = '0') then
            pc_reg       <= X"00";              -- after reset, PC is zero (i.e address 0)
            ir           <= X"0000";            -- NOP, no operation
            Addr_bus     <= X"00";              -- initialize registers
            cpu_reg_0    <= (others => '0');    -- initialize registers
            next_state   <= Fetch_1_state;
            bus_en_n     <= '1';
            data_bus_out <= "0000000000000000"; -- initialize registers
            WE_n         <= '1';
            RD_n         <= '1';
            CPU_state    <= "00";
        elsif (rising_edge(clk_50)) then
            -- initialize registers
            WE_n     <= '1';
            RD_n     <= '1';
            bus_en_n <= '1';

            case next_state is

                ---------- Fetch state
                when Fetch_1_state => -- Fetch instruction state
                    CPU_state  <= "00";
                    Addr_bus   <= std_logic_vector(pc_reg);
                    RD_n       <= '0';
                    bus_en_n   <= '0';
                    next_state <= Fetch_2_state;

                when Fetch_2_state => -- Fetch instruction state
                    CPU_state  <= "00";
                    RD_n       <= '0';
                    bus_en_n   <= '0';
                    next_state <= Fetch_3_state;

                when Fetch_3_state => -- Fetch instruction state
                    CPU_state  <= "00";
                    ir         <= data_bus_in;
                    next_state <= Decode_state;

                ---------- Decode state
                when Decode_state =>         -- Decode and execute instruction state
                    pc_reg    <= pc_reg + 1; -- PC pointing on next instruction
                    CPU_state <= "01";

                    case ir(15 downto 12) is -- Decode the instruction in ir reg

                        when nop =>   -- 0, nop
                            next_state <= Execute_NOP_state;
                        when load =>  -- 1
                            next_state <= Execute_LOAD_state;
                        when store => -- 2
                            next_state <= Execute_STORE_state;
                        when jmp =>
                            next_state <= Execute_JMP_state;
                        when others =>
                            next_state <= Fetch_1_state;

                    end case;

                ---------- execution stateJMP_state
                when Execute_NOP_state => -- Decode and execute instruction state
                                    CPU_state  <= "10";
                                    next_state <= Fetch_1_state;

                when Execute_LOAD_state =>                                     -- Decode and execute instruction state
                                    CPU_state              <= "10";
                                    -- cpu_reg_0(11 downto 0) <= ir(11 downto 0); -- Load data to CPU_REGISTER from adress ir(11 downto 0)
                                    cpu_reg_0              <= (15 downto 12 => '0') & ir(11 downto 0); -- Load data to CPU_REGISTER from adress ir(11 downto 0)
                                    next_state             <= Fetch_1_state;

                when Execute_STORE_state =>                                     -- Decode and execute instruction state
                                    CPU_state                <= "10";
                                    Addr_bus                 <= ir(7 downto 0); -- Store data from CPU_REGISTER to adress ir(7 downto 0)
                                    -- data_bus_out(7 downto 0) <= cpu_reg_0(7 downto 0);
                                    data_bus_out             <= (15 downto 8 => '0') & cpu_reg_0(7 downto 0);
                                    next_state               <= STORE_1_state;

                when Execute_JMP_state =>                                   -- Decode and execute instruction state
                                    CPU_state  <= "10";
                                    pc_reg     <= unsigned(ir(7 downto 0)); -- 3, Jump to adress ir(7 downto 0)
                                    next_state <= Fetch_1_state;

                ---------- Store state
                when STORE_1_state => -- Store data state (If needed)
                                    next_state <= STORE_2_state;
                                    CPU_state  <= "11";
                                    WE_n       <= '0';
                                    bus_en_n   <= '0';

                when STORE_2_state => -- Store data state (If needed)
                                    next_state <= Fetch_1_state;
                                    CPU_state  <= "11";
                                    WE_n       <= '1';
                                    bus_en_n   <= '1';

            end case;

        end if;

    end process;

end architecture rtl;


