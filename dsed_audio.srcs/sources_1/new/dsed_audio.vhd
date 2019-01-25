----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2018 21:33:01
-- Design Name: 
-- Module Name: dsed_audio - Behavioral
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

entity dsed_audio is
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
end dsed_audio;

architecture Behavioral of dsed_audio is

-- Declaration of components:
    component clk_12Mhz is 
               Port(
                   clk_out1 : out STD_LOGIC;
                   clk_in1 : in STD_LOGIC);
    end component;
    
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
    
    component fir_filter is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               sample_in : in SIGNED (sample_size-1 downto 0);
               sample_in_enable : in STD_LOGIC;
               filter_select : in STD_LOGIC;
               sample_out : out SIGNED (sample_size-1 downto 0);
               sample_out_ready : out STD_LOGIC);
    end component;
    
    component RAM
          Port (
            clka : IN STD_LOGIC;
            rsta : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            rsta_busy : OUT STD_LOGIC);
    end component;
    
    component controller_system is
            Port ( clk_12meg : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   BTNL : in STD_LOGIC;
                   BTNC : in STD_LOGIC;
                   BTNR : in STD_LOGIC;
                   SW0 : in STD_LOGIC;
                   SW1 : in STD_LOGIC;
               -- Audio in
                   sample_out_ready_audio : in STD_LOGIC;
                   sample_request_audio : in STD_LOGIC;
               -- Filter in
                   sample_out_ready_filter : in STD_LOGIC;
               -- Audio out
                   record_enable : out STD_LOGIC;
                   play_enable : out STD_LOGIC;
               -- RAM out
                   addr_RAM : out STD_LOGIC_VECTOR(18 downto 0);
                   read_write_RAM : out STD_LOGIC_VECTOR (0 TO 0);
                   enable_RAM : out STD_LOGIC;
               -- Filter out
                   enable_filter : out STD_LOGIC);                   
    end component;
    
    component bit_converter is
            Port ( clk_12meg : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   sample_out_ready_filter : in STD_LOGIC;
                   data_ram : in STD_LOGIC_VECTOR (7 downto 0);
                   sample_in_filter : out SIGNED (sample_size-1 downto 0);
                   sample_out_filter : in SIGNED (sample_size-1 downto 0);
                   sample_in_audio : out STD_LOGIC_VECTOR (sample_size-1 downto 0));
    end component;
    
-- declaration of signals:

    -- AUDIO INTERFACE
    signal clk_12Mhz_aux, record_enable_aux, play_enable_aux, sample_out_ready_audio_aux, sample_request_aux : std_logic;       
    signal sample_in_audio_aux, sample_out_audio_aux : std_logic_vector (sample_size-1 downto 0);
    
    -- FIR FILTER
    signal sample_in_filter_aux, sample_out_filter_aux : signed (sample_size-1 downto 0);        
    signal enable_filter_aux, sample_out_ready_filter_aux : std_logic;
    
    -- RAM
    signal enable_RAM_aux : std_logic;
    signal write_read_RAM_aux : std_logic_vector (0 to 0);
    signal addr_RAM_aux : std_logic_vector (18 downto 0);
    signal data_RAM_out_aux : std_logic_vector(7 downto 0);
    
    --CONVERTER
    signal sample_in_audio_convert : std_logic_vector (sample_size-1 downto 0);
    

begin

unit_clk_12megas : clk_12Mhz port map (
                                clk_in1 => clk_100Mhz,
                                clk_out1 => clk_12Mhz_aux
                                );

unit_audio_interface : audio_interface port map (
                                            clk_12megas => clk_12Mhz_aux,
                                            reset => reset,
                                            micro_data => micro_data,
                                            record_enable => record_enable_aux,
                                            play_enable => play_enable_aux,
                                            sample_in => sample_in_audio_aux,
                                            micro_clk => micro_clk,
                                            micro_LR => micro_LR,
                                            jack_sd => jack_sd,
                                            jack_pwm => jack_pwm,
                                            sample_out => sample_out_audio_aux,
                                            sample_out_ready => sample_out_ready_audio_aux,
                                            sample_request => sample_request_aux
                                            );

unit_fir_filter : fir_filter port map(
                                    clk => clk_12Mhz_aux,
                                    reset => reset,
                                    sample_in => sample_in_filter_aux,
                                    sample_in_enable => enable_filter_aux,
                                    filter_select => SW0,
                                    sample_out => sample_out_filter_aux,
                                    sample_out_ready => sample_out_ready_filter_aux
                                    );
                                    
unit_RAM : RAM port map (
                        clka => clk_12Mhz_aux,
                        rsta => reset,
                        ena => enable_RAM_aux,
                        wea => write_read_RAM_aux,
                        addra => addr_RAM_aux,
                        dina => sample_out_audio_aux,
                        douta => data_RAM_out_aux
                    );

unit_controller_system : controller_system port map (
                                                    clk_12meg => clk_12Mhz_aux,
                                                    reset => reset,
                                                    BTNL => BTNL,
                                                    BTNC => BTNC,
                                                    BTNR => BTNR,
                                                    SW0 => SW0,
                                                    SW1 => SW1,
                                                    sample_out_ready_audio => sample_out_ready_audio_aux,
                                                    sample_request_audio => sample_request_aux,
                                                    sample_out_ready_filter => sample_out_ready_filter_aux,
                                                    record_enable => record_enable_aux,
                                                    play_enable => play_enable_aux,
                                                    enable_filter => enable_filter_aux,
                                                    addr_RAM => addr_RAM_aux,
                                                    read_write_RAM => write_read_RAM_aux,
                                                    enable_RAM => enable_RAM_aux
                                                );

unit_bit_converter : bit_converter port map (
                                        clk_12meg => clk_12Mhz_aux,
                                        reset => reset,
                                        sample_out_ready_filter => sample_out_ready_filter_aux,
                                        data_ram => data_RAM_out_aux,
                                        sample_in_filter => sample_in_filter_aux,
                                        sample_out_filter => sample_out_filter_aux,
                                        sample_in_audio => sample_in_audio_convert
                                        );
    
    sample_in_audio_aux <= sample_in_audio_convert when SW1 = '1' else
                           data_RAM_out_aux;
    
end Behavioral;
