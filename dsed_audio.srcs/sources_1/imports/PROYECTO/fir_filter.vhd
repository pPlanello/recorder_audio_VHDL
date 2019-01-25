----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2018 17:35:34
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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

entity fir_filter is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in : in SIGNED (sample_size-1 downto 0);
           sample_in_enable : in STD_LOGIC;
           filter_select : in STD_LOGIC;
           sample_out : out SIGNED (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC);
end fir_filter;

architecture Behavioral of fir_filter is

--Statement component
    component data_path is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               filter_select : in STD_LOGIC;
               sample_in_enable : in STD_LOGIC; 
               sample_in : in SIGNED (sample_size-1 downto 0);
               control : in STD_LOGIC_VECTOR (2 downto 0);          -- signal of control unit
               control_end : in STD_LOGIC;
               y : out SIGNED (sample_size - 1 downto 0));
    end component;
    
    component control_filter is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               sample_in_enable : in STD_LOGIC;
               control : out STD_LOGIC_VECTOR (2 downto 0);
               control_end : out STD_LOGIC;
               sample_out_ready : out STD_LOGIC);
    end component;

-- Statement signals
    signal aux_control : std_logic_vector (2 downto 0) := "000";
    signal aux_control_end : std_logic := '0';
    
begin

unit_data_path : data_path port map (
                        clk => clk,
                        reset => reset,
                        filter_select => filter_select,
                        sample_in_enable => sample_in_enable,
                        sample_in => sample_in,
                        control => aux_control,
                        control_end => aux_control_end,
                        y => sample_out
                    );
                    
unit_control_filter : control_filter port map (
                                clk => clk,
                                reset => reset,
                                sample_in_enable => sample_in_enable,
                                control => aux_control,
                                control_end => aux_control_end,
                                sample_out_ready => sample_out_ready
                            );

end Behavioral;
