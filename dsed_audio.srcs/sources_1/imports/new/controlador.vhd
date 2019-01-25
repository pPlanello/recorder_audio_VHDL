----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2018 18:13:43
-- Design Name: 
-- Module Name: controlador - Behavioral
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

entity controlador is
    Port ( clk_100Mhz : in STD_LOGIC;
           reset : in STD_LOGIC;
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC);
end controlador;

architecture Behavioral of controlador is

--Copiar el que tenga puesto tal cual por si tiene algun comentario
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

component clk_12Mhz is 
    Port(
        clk_out1 : out STD_LOGIC;
        clk_in1 : in STD_LOGIC);
end component;

--Declaración de señales
signal clk_12MHz_aux  : STD_LOGIC := '0'; 
signal aux_sample_out_ready, aux_sample_request : STD_LOGIC := '0';
signal aux_sample_out : STD_LOGIC_VECTOR(sample_size-1 downto 0) := (others => '0'); --Hay que meter el sample_size


begin

 U_interface : audio_interface port map (
             clk_12megas => clk_12Mhz_aux,
             reset => reset,             
             record_enable => '1', 
             sample_out => aux_sample_out, 
             sample_out_ready => aux_sample_out_ready,  --Si las pongo iguales dice qeu no esta declaradas-> signals        
             micro_clk => micro_clk, 
             micro_data => micro_data,
             micro_LR => micro_LR,           
             play_enable => '1',
             sample_in => aux_sample_out,
             sample_request => aux_sample_request,
             jack_sd => jack_sd,
             jack_pwm => jack_pwm);
             
U_clk12Mhz : clk_12Mhz port map (
             clk_out1 => clk_12Mhz_aux,
             clk_in1 => clk_100Mhz
);          

end Behavioral;
