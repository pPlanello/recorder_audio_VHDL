----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2018 13:33:23
-- Design Name: 
-- Module Name: data_path_tb - Behavioral
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

use work.package_dsed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_path_tb is
--  Port ( );
end data_path_tb;

architecture Behavioral of data_path_tb is

-- Statement component
    component data_path is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               filter_select : in STD_LOGIC;
               sample_in_enable : in STD_LOGIC; 
               sample_in : in SIGNED (sample_size-1 downto 0);
               reset_control : in STD_LOGIC; -- reset of control unit
               control : in STD_LOGIC_VECTOR (2 downto 0); -- signal of control unit
               y : out SIGNED (sample_size-1 downto 0));
    end component;

-- Statement signal
    signal clk, reset, filter_select, sample_in_enable, reset_control : std_logic := '0';
    signal sample_in, y : signed (sample_size - 1 downto 0) := "00000000";
    signal control : std_logic_vector (2 downto 0) := "000"; 
    
    constant c_period : time := 83 ns;
 
    signal a_filter : SIGNED (sample_size - 1 downto 0) := "01100011";
    signal b_filter : SIGNED (sample_size - 1 downto 0) := "10001001";
    signal c_filter : SIGNED (sample_size - 1 downto 0) := "00100000";

    
begin

test_data_path : data_path port map (
                            clk => clk,
                            reset => reset,
                            filter_select => filter_select,
                            sample_in_enable => sample_in_enable,
                            sample_in => sample_in,
                            reset_control => reset_control,
                            control => control,
                            y => y
                        );
-- Process clk
    process
        begin
           clk <= '0';
           wait for c_period/2;  
           clk <= '1';
           wait for c_period/2;  
    end process;
    
-- Process type of filter:
process
    begin
        Reset <= '1';
        wait for 15 ns;
        reset <= '0';
        wait for 2ns;
        filter_select <= '1';
        wait for 2000 ns;
        wait;
end process;
    
-- Process to signals in
process
    begin
        control <= std_logic_vector(unsigned(control) + 1) after 200 ns;
        a_filter <= not a_filter after 1300 ns;
        b_filter <= not b_filter after 2100 ns;
        c_filter <= not c_filter after 3700 ns;
        
        sample_in <= a_filter xor b_filter xor c_filter;
        
        wait for 20 ns; 
end process;

 process
     begin
        wait for c_period;
        sample_in_enable <= '1';
        wait for c_period;
        sample_in_enable <= '0';
        wait for 8*c_period;
end process;
    
end Behavioral;
