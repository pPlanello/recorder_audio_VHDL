----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.12.2018 19:24:47
-- Design Name: 
-- Module Name: bit_converter_tb - Behavioral
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

entity bit_converter_tb is
--  Port ( );
end bit_converter_tb;

architecture Behavioral of bit_converter_tb is

-- Declaration of component:
    component bit_converter is
            Port ( 
                   clk_12meg : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   sample_out_ready_filter : in STD_LOGIC;
                   
                   data_ram : in STD_LOGIC_VECTOR (7 downto 0);
                   sample_in_filter : out SIGNED (sample_size-1 downto 0);
                   
                   sample_out_filter : in SIGNED (sample_size-1 downto 0);
                   sample_in_audio : out STD_LOGIC_VECTOR (sample_size-1 downto 0)          
                   );
    end component;

-- Declaration of signals:
    signal clk_12meg, reset, sample_out_ready_filter : std_logic := '0';
    signal data_ram, sample_in_audio : std_logic_vector (sample_size-1 downto 0) := (others => '0');
    signal sample_in_filter, sample_out_filter : signed (sample_size-1 downto 0) := (others => '0');
    
    constant c_period : time := 83 ns;
    
begin

test_bit_converter : bit_converter port map (
                                            clk_12meg => clk_12meg,
                                            reset => reset,
                                            sample_out_ready_filter => sample_out_ready_filter,
                                            data_ram => data_ram,
                                            sample_out_filter => sample_out_filter,
                                            sample_in_filter => sample_in_filter,
                                            sample_in_audio => sample_in_audio
                                        );

-- Process clk:
    process
        begin
           clk_12meg <= '0';
           wait for c_period/2;  
           clk_12meg <= '1';
           wait for c_period/2;  
    end process;
    
-- Process sample_out_ready_filter:
    process
        begin
            sample_out_ready_filter <= '0';
            wait for 3*c_period;
            sample_out_ready_filter <= '1';
            wait for c_period;
            sample_out_ready_filter <= '0';
            wait for 4*c_period;
            sample_out_ready_filter <= '1';
            wait for c_period;
            sample_out_ready_filter <= '0';
            wait for 2*c_period;
            sample_out_ready_filter <= '1';
            wait;
    end process;
    
    process
        begin
            wait for 2*c_period;
            data_ram <= "10110101";
            sample_out_filter <= "10110101";
            wait for (3/4)*c_period;
            data_ram <= "01110101";
            sample_out_filter <= "01110101";
            wait for 3*c_period;
            data_ram <= "10100000";
            sample_out_filter <= "10100000";
            wait for 2*c_period;
            data_ram <= "00000001";
            sample_out_filter <= "00000001";
    end process;
    
-- Process reset
    process
        begin
            reset <= '1';
            wait for c_period;
            reset <= '0';
            wait for c_period/2;
            wait;
    end process;
end Behavioral;
