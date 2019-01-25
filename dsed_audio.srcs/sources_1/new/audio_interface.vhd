----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2018 13:02:52
-- Design Name: 
-- Module Name: audio_interface - Behavioral
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

entity audio_interface is
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
end audio_interface;

architecture Behavioral of audio_interface is

-- Component statement
    component FSMD_microphone is 
        Port (  clk_12megas : in STD_LOGIC;
                reset : in STD_LOGIC;
                enable_4_cycles : in STD_LOGIC;
                micro_data : in STD_LOGIC;
                sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
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
    
    
    component pwm is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               en_2_cycles : in STD_LOGIC;
               sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
               sample_request : out STD_LOGIC;
               pwm_pulse : out STD_LOGIC);
    end component;

-- Statement auxiliars signals
signal aux_en_2_cycles, aux_en_4_cycles, aux_en_pwm, aux_en_4_cycles_rec : std_logic := '0'; 
    
begin

-- Conexion

ENA_4_CYCLES : en_4_cycles port map (
                                clk_12megas => clk_12megas,
                                reset => reset,
                                clk_3megas => micro_clk,
                                en_2_cycles => aux_en_2_cycles,
                                en_4_cycles => aux_en_4_cycles
                            );
FSMD_MICRO : FSMD_microphone port map (
                                clk_12megas => clk_12megas,
                                reset => reset,
                                enable_4_cycles => aux_en_4_cycles_rec,
                                micro_data => micro_data,
                                sample_out => sample_out,
                                sample_out_ready => sample_out_ready
                            );
     
PWM_U : pwm port map (
                clk_12megas => clk_12megas,
                reset => reset,
                en_2_cycles => aux_en_pwm,
                sample_in => sample_in,
                sample_request => sample_request,
                pwm_pulse => jack_pwm
            );
            
-- Input of PWM             
    aux_en_pwm <= aux_en_2_cycles and play_enable;
    aux_en_4_cycles_rec <= aux_en_4_cycles and record_enable;

-- Output of audio_interface             
    jack_sd <= '1';
    micro_lr <= '0';    -- a lot of noise
    --  micro_lr <= '1'; -- less noise

end Behavioral;
