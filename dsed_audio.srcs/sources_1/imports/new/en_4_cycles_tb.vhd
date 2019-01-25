----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2018 21:32:32
-- Design Name: 
-- Module Name: en_4_cycles_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity en_4_cycles_tb is
--  Port ( );
end en_4_cycles_tb;

architecture Behavioral of en_4_cycles_tb is

--Declaración del componente a usar:
    component en_4_cycles is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk_3megas : out STD_LOGIC;
               en_2_cycles : out STD_LOGIC;
               en_4_cycles : out STD_LOGIC);
    end component;

--Declaración de señales del test:
    signal clk_12megas : std_logic := '0';
    constant c_period : time := 83.3333 ns;
    signal reset : STD_LOGIC := '1';
    signal clk_3meg, en_2_cyc, en_4_cyc	: STD_LOGIC := '0';


begin

--Asignacion de señales con el componente:
Unit_1 : en_4_cycles port map(
            clk_12megas => clk_12megas,
            reset => reset,
            clk_3megas => clk_3meg,
            en_2_cycles => en_2_cyc,
            en_4_cycles => en_4_cyc
          );

-- Pruebas:
    process
    begin
       clk_12megas <= '0';
       wait for c_period;  
       clk_12megas <= '1';
       wait for c_period;  
    end process;
    
    process
        begin
            wait for 25 ns; reset <= '0';
            wait for 5 us;
            wait for 25 ns; reset <= '1';
            wait for 25 ns; reset <= '0';
            wait for 5 us;
            wait;
        end process;
    

end Behavioral;