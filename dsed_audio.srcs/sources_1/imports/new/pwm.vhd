----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.11.2018 12:07:48
-- Design Name: 
-- Module Name: pwm - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

use work.package_dsed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_2_cycles : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request : out STD_LOGIC;
           pwm_pulse : out STD_LOGIC);
end pwm;

architecture Behavioral of pwm is

-- signal statement
    signal r_reg, r_next : unsigned (sample_size downto 0) := (others => '0');
    signal buf_reg, buf_next : std_logic := '0';
    constant N_299 : unsigned(sample_size downto 0) := "100101011";  --- 299
    constant N_0 :  unsigned(sample_size downto 0) := (others => '0');
--    signal fin_count : std_logic := '0';
    signal aux_sample_in :  std_logic_vector(sample_size downto 0) := (others => '0');
    
begin

-- register & output buffer
    process (clk_12megas, reset)
        begin
            if (reset = '1') then
                r_reg <= (others => '0');
                buf_reg <= '0';
            elsif rising_edge(clk_12megas) then
                if (en_2_cycles = '1')then
                    r_reg <= r_next;
                    buf_reg <= buf_next;
                end if;
            end if;    
    end process;
    
    aux_sample_in <= '0'& sample_in;
    
-- next state logic 
    r_next <= N_0 when (r_reg = N_299) else
              r_reg + 1 ;
              
-- output logic
    buf_next <= '1' when (r_reg < unsigned(aux_sample_in) OR (r_next = N_0))  else
                '0';
                
    sample_request <= en_2_cycles when (r_reg = N_299) else
                      '0'; 
                          
    pwm_pulse <= buf_reg;  
    
end Behavioral;
