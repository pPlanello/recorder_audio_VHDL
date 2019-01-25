----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2018 09:59:46
-- Design Name: 
-- Module Name: fir_filter_tb_Matlab - Behavioral
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

use STD.TEXTIO.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir_filter_tb_Matlab is
--  Port ( );
end fir_filter_tb_Matlab;

architecture Behavioral of fir_filter_tb_Matlab is

-- Declaration of the component
    component fir_filter is
            Port ( clk : in STD_LOGIC;
                   reset : in STD_LOGIC;
                   sample_in : in SIGNED (sample_size-1 downto 0);
                   sample_in_enable : in STD_LOGIC;
                   filter_select : in STD_LOGIC;
                   sample_out : out SIGNED (sample_size-1 downto 0);
                   sample_out_ready : out STD_LOGIC);
    end component;
    
-- Clock signal declaration
    signal clk : std_logic := '0';
    
-- Declaration of the reading signal
    signal reset, sample_in_enable, filter_select, sample_out_ready : STD_LOGIC := '0';
    signal sample_In, sample_out : signed (sample_size - 1 downto 0) := (others => '0');
    
-- Clock period definitions
    constant c_period : time := 83 ns;

begin

filter_FIR : fir_filter port map (
                                clk => clk,
                                reset => reset,
                                sample_in => sample_in,
                                sample_in_enable => sample_in_enable,
                                filter_select => filter_select,
                                sample_out => sample_out,
                                sample_out_ready => sample_out_ready
                            );
-- Clock statement
    process
        begin
           clk <= '0';
           wait for c_period/2;  
           clk <= '1';
           wait for c_period/2;  
    end process;

-- Process     
    process
        begin
            reset <= '1';
            wait for 2 ns;
            reset <= '0';
            wait for 2ns;
            filter_select <= '1';
--            sample_in_enable <= '1';
            wait for 2000 ns;
--            filter_select <= '0';
--            wait for 2000 ns;
--            sample_in_enable <= '0';
            wait;
            
         end process;  
-- Process to active or desactive sample_in_enable
    process
         begin
            wait for c_period;
            sample_in_enable <= '1';
            wait for c_period;
            sample_in_enable <= '0';
            wait for 8 * c_period;
     end process;
     
read_process : process (clk)
                    file in_file : text open read_mode is "C:\Users\plane\Documents\ETSIT\DSED\PROYECTO\Pruebas_matlab\sample_in.dat";
                    file out_file : text open write_mode is "C:\Users\plane\Documents\ETSIT\DSED\PROYECTO\Pruebas_matlab\sample_out.dat";
                    variable in_line, out_line : line;
                    variable in_int, out_int : integer;
                    variable in_read_ok : boolean;
                begin
                    if (rising_edge(clk)) then
                        if (not endfile(in_file)) then
                                if (sample_in_enable = '1') then
                                    ReadLine(in_file, in_line);
                                    Read(in_line, in_int, in_read_ok);
                                    sample_in <= to_signed(in_int, 8);      -- 8 = the bit width
                                end if;
                                
                                if (sample_out_ready = '1') then             
                                    out_int := to_integer(Sample_Out);
                                    Write(out_line, out_int);
                                    WriteLine(out_file, out_line);
                                end if;
                        else
                            assert false report "Simulation Finished" severity failure;
                        end if;
                    end if; 
                end process;

end Behavioral;
