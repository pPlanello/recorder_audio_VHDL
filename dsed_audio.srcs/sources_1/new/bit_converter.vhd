----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2018 22:37:15
-- Design Name: 
-- Module Name: bit_converter - Behavioral
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

entity bit_converter is
    Port ( 
           clk_12meg : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_out_ready_filter : in STD_LOGIC;
           
           data_ram : in STD_LOGIC_VECTOR (7 downto 0);
           sample_in_filter : out SIGNED (sample_size-1 downto 0);
           
           sample_out_filter : in SIGNED (sample_size-1 downto 0);
           sample_in_audio : out STD_LOGIC_VECTOR (sample_size-1 downto 0)          
           );
end bit_converter;

architecture Behavioral of bit_converter is

    signal sample_in_audio_next : std_logic_vector (sample_size-1 downto 0);

begin

    process (clk_12meg, reset)
        begin
            if rising_edge (clk_12meg) then
                if (reset = '1') then
                    sample_in_audio <= (others => '0');
                else
                    if (sample_out_ready_filter = '1') then
                        sample_in_audio <= sample_in_audio_next;
                    end if;
                end if;
            end if;
    end process;
    
    sample_in_audio_next <= std_logic_vector( (not sample_out_filter(7)) & sample_out_filter(6 downto 0) );
    
    sample_in_filter <= signed( (not data_ram(7)) & data_ram(6 downto 0) );

end Behavioral;
