----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2018 10:14:47
-- Design Name: 
-- Module Name: audio_interface_tb - Behavioral
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

entity audio_interface_tb is
--  Port ( );
end audio_interface_tb;

architecture Behavioral of audio_interface_tb is

-- Statement of component
    component audio_interface is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           --Recording ports
           --To/From the controller
           record_enable : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC;
           --To/From the microphone
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           --Playing ports
           --To/From the controller
           play_enable : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request : out STD_LOGIC;
           --To/From the mini-jack
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC);
end component;

-- Statement signals
signal clk_12megas, reset, record_enable, micro_data, play_enable : STD_LOGIC := '0';                       --Input
signal sample_out_ready, micro_clk, micro_LR, sample_request, jack_sd, jack_pwm : STD_LOGIC := '0';         --Output

signal sample_out, sample_in : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "00000000";

signal a_micro, b_micro, c_micro : STD_LOGIC := '0';
signal a_sample : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "01100011";
signal b_sample : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "10001001";
signal c_sample : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "00100000";

constant c_period : time := 83 ns;


begin


aud_interface : audio_interface port map (
                     clk_12megas =>  clk_12megas,
                     reset => reset,
                     record_enable => record_enable,
                     sample_out => sample_out,
                     sample_out_ready => sample_out_ready,
                     micro_clk => micro_clk,
                     micro_data => micro_data,
                     micro_LR => micro_LR,
                     play_enable => play_enable,
                     sample_in => sample_in,
                     sample_request => sample_request,
                     jack_sd => jack_sd,
                     jack_pwm => jack_pwm 
                );

-- Process to clk test
    process
       begin
           clk_12megas <= '0';
           wait for c_period/2;  
           clk_12megas <= '1';
           wait for c_period/2;  
    end process;

-- Process to reset
    process
        begin
            reset <= '1';
            wait for 10 ns;
            reset <= '0';
            wait;
    end process;

-- Process to signals in
    process
        begin
            record_enable <= '1';
            play_enable <= '1';
            
            a_micro <= not a_micro after 1300 ns;
            a_sample <= not a_sample after 1300 ns;
            
            b_micro <= not b_micro after 2100 ns;
            b_sample <= not b_sample after 2100 ns;
            
            c_micro <= not c_micro after 3700 ns;
            c_sample <= not c_sample after 3700 ns;
            
            micro_data <= a_micro xor b_micro xor c_micro;
            --sample_in <= a_sample xor b_sample xor c_sample;
            wait for 20 ns; 
    end process;
    
    sample_in <= std_logic_vector(unsigned(sample_in) + 5) after 50 us;

end Behavioral;
