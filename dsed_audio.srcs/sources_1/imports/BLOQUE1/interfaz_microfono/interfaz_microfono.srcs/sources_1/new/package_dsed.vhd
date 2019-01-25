library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package package_dsed is

    constant sample_size : integer := 8;
    
-- Low Pass Filter
    constant c0_LPF, c4_LPF : signed (sample_size - 1 downto 0) := "00000101";      -- +0,039
    constant c1_LPF, c3_LPF : signed (sample_size - 1 downto 0):= "00011111";       -- +0,2422
    constant c2_LPF : signed (sample_size - 1 downto 0) := "00111001";              -- +0,4453       
    
-- High Pass Filter
    constant c0_HPF, c4_HPF : signed (sample_size - 1 downto 0) := "11111111";      -- -0,0078              
    constant c1_HPF, c3_HPF : signed (sample_size - 1 downto 0):= "11100110";       -- -0,2031
    constant c2_HPF : signed (sample_size - 1 downto 0) := "01001101";              -- +0,6015
    
end package_dsed;
