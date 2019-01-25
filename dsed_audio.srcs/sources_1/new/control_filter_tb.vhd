----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2018 13:52:56
-- Design Name: 
-- Module Name: control_filter_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_filter_tb is
--  Port ( );
end control_filter_tb;

architecture Behavioral of control_filter_tb is

-- Statement component
    component control_filter is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               sample_in_enable : in STD_LOGIC;
               control : out STD_LOGIC_VECTOR (2 downto 0);
               control_end : out STD_LOGIC;
               sample_out_ready : out STD_LOGIC);
    end component;
    
-- Statement signal
    signal clk, reset, sample_in_enable, control_end : std_logic := '0';
    signal  sample_out_ready : std_logic :='0';
    signal control : std_logic_vector (2 downto 0) := "000";
    
    constant c_period : time := 83 ns;
    
begin

test_control_filter : control_filter port map (
                                        clk => clk,
                                        reset => reset,
                                        sample_in_enable => sample_in_enable,
                                        control => control,
                                        control_end => control_end,
                                        sample_out_ready => sample_out_ready
                                    );
-- Process clk
    process
        begin
           clk <= '0';
           wait for c_period/2;  
           clk <= '1';
           wait for c_period/2;  
    end process;
    
-- 
    process
        begin
            wait for 5 ns; 
            wait for 10 ns; reset <= '1'; 
            wait for 30 ns; reset <= '0'; 
            wait for 74 ns; sample_in_enable <= '1';
--            wait for 64 ns; sample_in_enable <= '0';
--            wait for 1 us; sample_in_enable <= '1';
--            wait for 64 ns; sample_in_enable <= '0';
            wait for 50 us;
            wait for 20 ns; 
            wait;
    end process;   

end Behavioral;
