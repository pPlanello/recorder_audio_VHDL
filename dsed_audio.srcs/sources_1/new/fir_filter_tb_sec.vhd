----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2018 14:20:59
-- Design Name: 
-- Module Name: fir_filter_tb_sec - Behavioral
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

entity fir_filter_tb_sec is
--  Port ( );
end fir_filter_tb_sec;

architecture Behavioral of fir_filter_tb_sec is

-- Statement component
    component fir_filter is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               sample_in : in SIGNED (sample_size-1 downto 0);
               sample_in_enable : in STD_LOGIC;
               filter_select : in STD_LOGIC;
               sample_out : out SIGNED (sample_size-1 downto 0);
               sample_out_ready : out STD_LOGIC);
    end component;
        
-- Statement signal
    signal clk, reset, sample_in_enable, filter_select, sample_out_ready : std_logic :='0';
    signal sample_in, sample_out : signed (sample_size-1 downto 0);
    
    constant c_period : time := 83 ns;
         
begin

test_fir_filter : fir_filter port map (
                                clk => clk,
                                reset => reset,
                                sample_in => sample_in,
                                sample_in_enable => sample_in_enable,
                                filter_select => filter_select,
                                sample_out => sample_out,
                                sample_out_ready => sample_out_ready
                            );

-- Process clk:
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
            wait for 2 ns;
            Reset <= '0';
            wait for 2ns;
            filter_select <= '1';
            wait for 2000 ns;
            wait;
    end process;
 
 -- Process with sequence   
    process
         begin
            wait for 9 * c_period;
            sample_in <= "01000000";    -- 0.5
            wait for 9 * c_period;
            sample_in <= "00000000";    -- 0.0
            wait for 9 * c_period;
            sample_in <= "00010000";    -- 0.125
            wait for 9 * c_period;
            sample_in <= "00000000";    -- 0.0
            wait for 4 * 9 * c_period;
     end process; 

     process
         begin
            wait for c_period;
            sample_in_enable <= '1';
            wait for c_period;
            sample_in_enable <= '0';
            wait for 8 * c_period;
     end process;


end Behavioral;
