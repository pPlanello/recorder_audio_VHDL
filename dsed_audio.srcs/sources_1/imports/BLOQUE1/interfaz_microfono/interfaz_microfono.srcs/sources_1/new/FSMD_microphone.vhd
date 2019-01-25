----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2018 12:04:47
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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

entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is

-- Signals states statement
    type state_type is (state_0_to_105, state_106_to_149, state_150_to_255, state_256_to_299);
    signal current_state, next_state : state_type;

-- Constant number statement
    constant N_105 : std_logic_vector (8 downto 0) := "001101001";      -- 105
    constant N_149 : std_logic_vector (8 downto 0) := "010010101";      -- 149
    constant N_255 : std_logic_vector (8 downto 0) := "011111111";      -- 255
    constant N_299 : std_logic_vector (8 downto 0) := "100101011";      -- 299
    
-- Signals statement
signal count_next, count_reg : std_logic_vector (8 downto 0) := (others => '0'); 

signal data1, data1_next : std_logic_vector (sample_size-1 downto 0) := (others => '0');
signal data2, data2_next : std_logic_vector (sample_size-1 downto 0) := (others => '0');

signal fin_cycle, fin_cycle_next : std_logic := '0';

signal aux_sample_out, aux_sample_out_next : std_logic_vector(sample_size-1 downto 0) := (others => '0');
signal aux_sample_out_ready : std_logic := '0';


begin

-- State and Registers of data
    process (clk_12megas, reset, enable_4_cycles)
        begin
            if (reset = '1') then
                current_state <= state_0_to_105;
                count_reg <= (others => '0');
                data1 <= (others => '0');
                data2 <= (others => '0');
                aux_sample_out <= aux_sample_out_next;
                fin_cycle <= fin_cycle_next;
                 
            elsif rising_edge(clk_12megas) then
                if (enable_4_cycles = '1') then
                    current_state <= next_state;
                    count_reg <= count_next;
                    data1 <= data1_next;
                    data2 <= data2_next;
                    aux_sample_out <= aux_sample_out_next;
                    fin_cycle <= fin_cycle_next;    
                end if;
            end if;
    end process;

-- FSMD
    process (current_state, count_reg, fin_cycle, data1, data2, aux_sample_out, micro_data, enable_4_cycles)
        begin
        -- Defected values
            data1_next <= data1;
            data2_next <= data2;
            fin_cycle_next <= fin_cycle;
            aux_sample_out_next <= aux_sample_out;
            aux_sample_out_ready <= '0';
            count_next <= count_reg;
            
        -- Transition of state
            case current_state is
             
                when state_0_to_105 =>                                                  -- COUNT 0 TO 105
                    count_next <= std_logic_vector(unsigned(count_reg) + 1);               -----------------------
                    
                    if (micro_data = '1') then
                        data1_next <= std_logic_vector(unsigned(data1) + 1);
                        if (data2 = N_255) then
                            data2_next <= N_255;
                        else
                            data2_next <= std_logic_vector(unsigned(data2) + 1);
                        end if;
                    end if;
                    
                    if (count_reg = N_105) then
                        data2_next <= (others => '0');
                        if (fin_cycle = '1') then
                           aux_sample_out_next <= data2;
                           aux_sample_out_ready <= enable_4_cycles;
                        end if;
                    else
                        aux_sample_out_ready <= '0';
                    end if;
                    
                    if (count_reg < N_105) then                                             -- transition to next state
                        next_state <= state_0_to_105;
                    else
                        next_state <= state_106_to_149;
                        aux_sample_out_next <= data2;          
                    end if;           
                
                
                when state_106_to_149 =>                                                -- COUNT 106 TO 149:
                    count_next <= std_logic_vector(unsigned(count_reg) + 1);               -----------------------
                    
                    if (micro_data = '1') then                                              -- stable data 2 signal
                        data1_next <= std_logic_vector(unsigned(data1) + 1);
                    end if;
                    
               -- ASTERISCO
--                    if (fin_cycle = '1' and count_reg = N_106) then                         
--                        aux_sample_out_next <= data2;
--                        data2_next <= (others => '0');
--                        aux_sample_out_ready <= enable_4_cycles; 
--                    else 
--                        aux_sample_out_ready <= '0';
--                    end if;
                    
                    if (count_reg < N_149) then                                             -- transition to next state
                        next_state <= state_106_to_149;
                    else 
                        next_state <= state_150_to_255;
                    end if;
                
                    
                when state_150_to_255 =>                                                -- COUNT 150 TO 255
                    count_next <= std_logic_vector(unsigned(count_reg) + 1);               -----------------------
                        
                        if (micro_data = '1') then
                            data2_next <= std_logic_vector(unsigned(data2) + 1);
                            if (data1 = N_255) then
                                data1_next <= N_255;
                            else
                                data1_next <= std_logic_vector(unsigned(data1) + 1);
                            end if;
                        end if;
                        
                        if (count_reg = N_255) then
                            aux_sample_out_next <= data1;
                            data1_next <= (others => '0');
                            aux_sample_out_ready <= enable_4_cycles;
                        else 
                            aux_sample_out_ready <= '0';
                        end if;
                        
                        if (count_reg < N_255) then                                         -- transition to next state
                            next_state <= state_150_to_255;
                        else
                            next_state <= state_256_to_299;
                            aux_sample_out_next <= data1;         
                        end if;
                
                when state_256_to_299 =>                                                -- Count 256 to 299
                    count_next <= std_logic_vector(unsigned(count_reg) + 1);               -----------------------
                        
                        if (micro_data = '1') then                                          -- stable data 1 signal
                            data2_next <= std_logic_vector(unsigned(data2) + 1);
                        end if;
                        
              -- ASTERISCO
--                        if (fin_cycle = '1' and count_reg = N_256) then                     
--                            aux_sample_out_next <= data1;
--                            data1_next <= (others => '0');
--                            aux_sample_out_ready <= enable_4_cycles; 
--                        else 
--                            aux_sample_out_ready <= '0';
--                        end if;
                        
                        if (count_reg = N_299) then                                         -- transition to next state
                            count_next <= (others => '0');
                            fin_cycle_next <= '1';
                            next_state <= state_0_to_105;
                        else 
                            next_state <= state_256_to_299;
                        end if;        
            end case;
    end process;
    
    sample_out <= aux_sample_out;
    sample_out_ready <= aux_sample_out_ready;
    
end Behavioral;
