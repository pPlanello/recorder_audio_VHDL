----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2018 16:15:26
-- Design Name: 
-- Module Name: control_filter - Behavioral
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

entity control_filter is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in_enable : in STD_LOGIC;
           control : out STD_LOGIC_VECTOR (2 downto 0);
           control_end : out STD_LOGIC;
           sample_out_ready : out STD_LOGIC);
end control_filter;

architecture Behavioral of control_filter is

-- Signals states statement
    type state_type is (idle, state_t1_to_t8);
    signal current_state, next_state : state_type;
    
-- Statement signals
    signal control_next, control_reg : unsigned (2 downto 0) := "110";
    signal aux_control_end : std_logic := '0';
     
    
begin

-- State and Registers of data
    process (clk, reset)
        begin
            if rising_edge(clk) then
                if (reset = '1') then
                    current_state <= idle;
                    control_reg <= "110";
                else
                    current_state <= next_state;
                    control_reg <= control_next;                    
                end if;
            end if;
            
    end process;

-- FSMD
    process (current_state, control_reg, sample_in_enable)
        begin
        -- Defect values
            control_next <= control_reg;
            next_state <= current_state;
            sample_out_ready <= '0';
            control_end <= '0';
            
        --Transition of state
            case current_state is 
                when idle =>
                    if (sample_in_enable = '1') then
                        next_state <= state_t1_to_t8;
                        control_next <= "000";
                    else 
                        next_state <= idle;
                        control_next <= "110"; 
                    end if;
                    
                    
                when state_t1_to_t8 =>
                    control_next <= control_reg + 1;
                    
                    if (control_reg = "111") then
                        sample_out_ready <= '1';
                        control_end <= '1';
                        next_state <= idle;
                        control_next <="110"; 
                    else 
                        next_state <= state_t1_to_t8;
                    end if; 
            end case;
    end process;
    
    control <= std_logic_vector(control_reg);

end Behavioral;
