----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.01.2019 11:28:01
-- Design Name: 
-- Module Name: audio_global_tb - Behavioral
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

entity audio_global_tb is
--  Port ( );
end audio_global_tb;

architecture Behavioral of audio_global_tb is

-- Declaration component
    component dsed_audio is
        Port ( clk_100Mhz : in STD_LOGIC;
               reset : in STD_LOGIC;
               --Control ports
               BTNL : in STD_LOGIC;
               BTNC : in STD_LOGIC;
               BTNR : in STD_LOGIC;
               SW0 : in STD_LOGIC;
               SW1 : in STD_LOGIC;
               --To/From the microphone
               micro_clk : out STD_LOGIC;
               micro_data : in STD_LOGIC;
               micro_LR : out STD_LOGIC;
               --To/From the mini-jack
               jack_sd : out STD_LOGIC;
               jack_pwm : out STD_LOGIC);
    end component;
    
-- Declaration signal
    signal clk_100Mhz, reset, BTNL, BTNC, BTNR, SW0, SW1, micro_data : STD_LOGIC := '0';
    signal micro_clk, micro_LR, jack_sd, jack_pwm : STD_LOGIC := '0';
    
    constant c_period : time := 10 ns;
    
    signal a_micro, b_micro, c_micro : STD_LOGIC := '0';
    signal a_sample : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "01100011";
    signal b_sample : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "10001001";
    signal c_sample : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "00100000";
    
begin
test_global_audio : dsed_audio port map(
                            clk_100Mhz => clk_100Mhz,
                            reset => reset,
                            BTNL => BTNL,
                            BTNC => BTNC,
                            BTNR => BTNR,
                            SW0 => SW0,
                            SW1 => SW1,
                            micro_clk => micro_clk,
                            micro_data => micro_data,
                            micro_LR => micro_LR,
                            jack_sd => jack_sd,
                            jack_pwm => jack_pwm
            );

-- Process clk:
    process
        begin
           clk_100Mhz <= '0';
           wait for c_period/2;  
           clk_100Mhz <= '1';
           wait for c_period/2;  
    end process;

-- Process test:
    process
        begin
            wait for 40 ns;          -- grabando
            BTNL <= '1';
            
            wait for 600 us;
            BTNL <= '0';
            
            wait for 10 us;
            BTNR <= '1';                -- reproduce
            SW0 <= '0';
            SW1 <= '0';
            
            wait for 100 ns;
            BTNR <= '0';    
            
            wait;
    end process;


    a_micro <= not a_micro after 1300 ns;
--    a_sample <= not a_sample after 1300 ns;
    
    b_micro <= not b_micro after 2100 ns;
--    b_sample <= not b_sample after 2100 ns;
    
    c_micro <= not c_micro after 3700 ns;
--    c_sample <= not c_sample after 3700 ns;
    
    micro_data <= a_micro xor b_micro xor c_micro;
    
end Behavioral;
