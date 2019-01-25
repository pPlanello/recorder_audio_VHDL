----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2018 12:22:25
-- Design Name: 
-- Module Name: FSMD_microphone_tb - Behavioral
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

entity FSMD_microphone_tb is
--  Port ( );
end FSMD_microphone_tb;

architecture Behavioral of FSMD_microphone_tb is

-- Declaracion de componente:
    component FSMD_microphone is 
        Port (  clk_12megas : in STD_LOGIC;
                reset : in STD_LOGIC;
                enable_4_cycles : in STD_LOGIC;
                micro_data : in STD_LOGIC;
                sample_out : out STD_LOGIC_VECTOR (8-1 downto 0);
                sample_out_ready : out STD_LOGIC
        );
    end component;
    
    component en_4_cycles is 
            Port (  clk_12megas : in STD_LOGIC;
                    reset : in STD_LOGIC;
                    clk_3megas : out STD_LOGIC;
                    en_2_cycles : out STD_LOGIC;
                    en_4_cycles : out STD_LOGIC                   
            );
    end component;  

-- Declaracion de variables de prueba:
    signal clk_3megas, en_2_cycles : STD_LOGIC := '0';
    signal rst_aux, enable_4_cycles, micro_data, sample_out_ready, clk_12megas_aux : STD_LOGIC := '0';
    signal sample_out : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    constant c_period : time := 8.33333 ns;
    
begin

unit_test_0 : en_4_cycles port map (
                                clk_12megas => clk_12megas_aux,
                                reset => rst_aux,
                                clk_3megas => clk_3megas,
                                en_2_cycles => en_2_cycles,
                                en_4_cycles => enable_4_cycles
                                );
unit_test_1 : FSMD_microphone port map (
                                clk_12megas => clk_12megas_aux,
                                reset => rst_aux,
                                enable_4_cycles => enable_4_cycles,
                                micro_data => micro_data,
                                sample_out => sample_out,
                                sample_out_ready => sample_out_ready
                                );

--Pruebas
    process                 -- reloj de prueba de 10 ns 
        begin
           clk_12megas_aux <= '0';
           wait for c_period;  
           clk_12megas_aux <= '1';
           wait for c_period;  
    end process;
    
    process
        begin
            wait for 5 ns; 
            wait for 10 ns; rst_aux <= '1'; 
            wait for 20 ns; rst_aux <= '0'; micro_data <= '1';
            wait for 50 us; rst_aux <= '1';
            wait for 20 ns; rst_aux <= '0'; 
            wait;
    end process;                       

end Behavioral;
