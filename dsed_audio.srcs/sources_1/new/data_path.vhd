----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2018 17:40:14
-- Design Name: 
-- Module Name: data_path - Behavioral
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

entity data_path is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           filter_select : in STD_LOGIC;
           sample_in_enable : in STD_LOGIC; 
           sample_in : in SIGNED (sample_size-1 downto 0);
           control : in STD_LOGIC_VECTOR (2 downto 0); -- signal of control unit
           control_end : in STD_LOGIC;
           y : out SIGNED (sample_size-1 downto 0));
end data_path;

architecture Behavioral of data_path is

-- Statement auxiliars signals:
    signal reg_1, reg_1_next, reg_2, reg_2_next, reg_3, reg_3_next : signed ( 2*sample_size-1 downto 0) := "0000000000000000";
    signal c0, c1, c2, c3, c4, x0, x1, x2, x3, x4 : signed (sample_size - 1 downto 0) := "00000000";
    signal out_mult_m1, out_mult_m2 : signed (sample_size - 1 downto 0) := "00000000";
    
    signal out_mult : signed (2*sample_size-1 downto 0) := "0000000000000000";

begin

------------------Constant value of the filter------------------------
-- Value of C0
    with filter_select select
            c0 <=                
                c0_LPF when '0',            -- 0 to low filter
                c0_HPF when others;         -- 1 to high filter
-- Value of C1                
    with filter_select select
            c1 <=                    
                c1_LPF when '0',            -- 0 to low filter
                c1_HPF when others;         -- 1 to high filter
-- Value of C2
    with filter_select select
            c2 <=                
                c2_LPF when '0',            -- 0 to low filter
                c2_HPF when others;         -- 1 to high filter
-- Value of C3                
    with filter_select select
            c3 <=                    
                c3_LPF when '0',            -- 0 to low filter
                c3_HPF when others;         -- 1 to high filter
-- Value of C4                
    with filter_select select
            c4 <=                    
                c4_LPF when '0',            -- 0 to low filter
                c4_HPF when others;         -- 1 to high filter
------------------------------------------------------------------------

-- Mux_1: mux 5 inputs
    with control select
            out_mult_m1 <= 
                c0 when "000",
                c1 when "001",
                c2 when "010",
                c3 when "011",
                c4 when "100",
                (others => '0') when others;
-- Mux_2: mux 5 inputs    
    with control select
            out_mult_m2 <= 
                x0 when "000",
                x1 when "001",
                x2 when "010",
                x3 when "011",
                x4 when "100",
                (others => '0') when others;

-- Register
    process (clk, reset)
        begin
           if (rising_edge(clk)) then
                if (reset = '1') then                                                         
                    reg_1 <= (others => '0');        -- all signals to null
                    reg_2 <= (others => '0');
                    reg_3 <= (others => '0');
                    out_mult <= (others => '0');
                    x0 <= (others => '0');
                    x1 <= (others => '0');
                    x2 <= (others => '0');
                    x3 <= (others => '0');
                    x4 <= (others => '0');
                else
                    if (control_end = '0') then                  -- If is not finished the word do this:
                        if (sample_in_enable = '1') then         
                            x0 <= sample_in;
                            x1 <= x0;
                            x2 <= x1;
                            x3 <= x2;
                            x4 <= x3;
                        end if; 
                        
                        out_mult <= out_mult_m1 * out_mult_m2;
                        
                        reg_1 <= reg_1_next;
                        reg_2 <= reg_2_next;
                        reg_3 <= reg_3_next;
                    else                                        -- If is finished the word:
                        reg_3 <= (others => '0');                       -- reset register
                    end if;
                end if;
            end if;
    end process;
    
    
    
 -- next state logic
    reg_1_next <= out_mult;
    reg_2_next <= reg_1;
    reg_3_next <= reg_3 + reg_2;
    
 -- output logic  
    y <= reg_3( 2*(sample_size-1) downto sample_size-1); 
               
end Behavioral;
