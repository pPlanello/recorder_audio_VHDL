----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.11.2018 13:01:38
-- Design Name: 
-- Module Name: pwm_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm_tb is
--  Port ( );
end pwm_tb;

architecture Behavioral of pwm_tb is

-- component statement 
    component pwm is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               en_2_cycles : in STD_LOGIC;
               sample_in : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
               sample_request : out STD_LOGIC;
               pwm_pulse : out STD_LOGIC);
    end component;
    
    component en_4_cycles is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk_3megas : out STD_LOGIC;
               en_2_cycles : out STD_LOGIC;
               en_4_cycles : out STD_LOGIC);
    end component;
    
-- signal statement
    signal clk_12megas, reset, aux_en_2_cycles,  sample_request, pwm_pulse : std_logic := '0';
    signal aux_en_4_cycles, clk_3megas : std_logic := '0';
    signal sample_in : std_logic_vector (sample_size-1 downto 0) := "00000000";
--    signal aux_sample_in : std_logic_vector (sample_size downto 0) := "000000000";
    
    signal a : std_logic_vector (sample_size downto 0) := "001100011";
    signal b : std_logic_vector (sample_size downto 0) := "010001001";
    signal c : std_logic_vector (sample_size  downto 0) := "000100000";
    
    
    constant c_period : time := 8.33333 ns;
    
--    constant sample_size : integer := 8;
    
begin

-- component test

test_EN_4_CYCLES: en_4_cycles port map(
                         clk_12megas =>  clk_12megas,
                         reset => reset,
                         clk_3megas => clk_3megas,
                         en_2_cycles => aux_en_2_cycles,
                         en_4_cycles => aux_en_4_cycles
                     );
                     
test_PWM: pwm port map(
                 clk_12megas =>  clk_12megas,
                 reset => reset,
                 en_2_cycles => aux_en_2_cycles,
                 sample_in => sample_in,
                 sample_request => sample_request,
                 pwm_pulse => pwm_pulse
             );


-- process to clk test 
	process
        begin
           clk_12megas <= '0';
           wait for c_period/2;  
           clk_12megas <= '1';
           wait for c_period/2;  
    end process;
    
    
-- signal in process
    process
        begin
            sample_in <= "11111111";
--            sample_in <= "000000000";
--            a <= not a after 1300 ns;
--            b <= not b after 2100 ns;
--            c <= not c after 3700 ns;
--            sample_in <= a xor b xor c;
            wait for 20 ns;        
    end process;

end Behavioral;
