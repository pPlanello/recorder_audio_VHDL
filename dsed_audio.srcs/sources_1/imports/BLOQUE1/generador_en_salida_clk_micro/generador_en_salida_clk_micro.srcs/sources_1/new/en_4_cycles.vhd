----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2018 20:18:31
-- Design Name: 
-- Module Name: en_4_cycles - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end en_4_cycles;

architecture Behavioral of en_4_cycles is

-- Signals statement:
    signal aux_clk_3meg, aux_en_2_cy, aux_en_4_cy : std_logic := '0';
    signal cycle_counter_reg, cycle_counter_next  : unsigned (1 downto 0) := (others => '0');
    
    signal aux_cycle_1,  aux_cycle_2,  aux_cycle_3, aux_2_en, aux_3_en : std_logic := '0'; 

begin

-- register & output buffer
    process (clk_12megas, reset)
        begin
           if rising_edge(clk_12megas) then
                if (reset = '1') then
                   cycle_counter_reg <= (others => '0');
                else
                    cycle_counter_reg <= cycle_counter_next;
                end if;
            end if;    
    end process;

-- next state logic
    cycle_counter_next <= cycle_counter_reg + 1;
    
-- output logic
    aux_cycle_1 <= '1' when (cycle_counter_reg = "01") else
                    '0';
    aux_cycle_2 <= '1' when (cycle_counter_reg = "10") else
                    '0';                      
    aux_cycle_3 <= '1' when (cycle_counter_reg = "11") else
                    '0';
    en_4_cycles <= '1' when aux_cycle_2='1' else
                    '0';
                    
    aux_3_en <= aux_cycle_2 or aux_cycle_3;
                    
    clk_3megas <= '1' when aux_3_en='1' else
                  '0';
    aux_2_en <= aux_cycle_1 or aux_cycle_3;
    
    en_2_cycles <= '1' when (aux_2_en = '1') else
                    '0';              


end Behavioral;
