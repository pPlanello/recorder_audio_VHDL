----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2018 13:03:57
-- Design Name: 
-- Module Name: controller_system_tb_idle - Behavioral
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

entity controller_system_tb_play is
--  Port ( );
end controller_system_tb_play;


architecture Behavioral of controller_system_tb_play is

-- Declaration of component:
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
           -- audio out
               record_enable : out STD_LOGIC;
               play_enable : out STD_LOGIC;
           -- RAM out
               addr_RAM : out STD_LOGIC_VECTOR(18 downto 0);
               read_write_RAM : out STD_LOGIC_VECTOR (0 TO 0);
               enable_RAM : out STD_LOGIC;
               -- Filter out
               enable_filter : out STD_LOGIC);
    end component;

-- Declaration of signals
    -- inputs
    signal clk_12meg, reset, BTNC, BTNL, BTNR, SW0, SW1 : std_logic := '0';
    signal sample_out_ready_audio, sample_request_audio, sample_out_ready_filter : std_logic := '0';
    -- outputs
    signal record_enable, play_enable, enable_RAM, enable_filter : std_logic := '0';
    signal addr_RAM : std_logic_vector (18 downto 0) := "1101010010000001000";
    signal read_write_RAM : std_logic_vector (0 to 0) := "0";
    
    constant c_period : time := 83 ns;
    
begin

test_controller_system_play : controller_system port map (
                                                            clk_12meg => clk_12meg,
                                                            reset => reset,
                                                            BTNC => BTNC,
                                                            BTNR => BTNR,
                                                            BTNL => BTNL,
                                                            SW0 => SW0,
                                                            SW1 => SW1,
                                                            sample_out_ready_audio => sample_out_ready_audio,
                                                            sample_request_audio => sample_request_audio,
                                                            sample_out_ready_filter => sample_out_ready_filter,
                                                            record_enable => record_enable,
                                                            play_enable => play_enable,
                                                            enable_RAM => enable_RAM,
                                                            enable_filter => enable_filter,
                                                            addr_RAM => addr_RAM,
                                                            read_write_RAM => read_write_RAM
                                                        );

-- Process clk:
    process
        begin
           clk_12meg <= '0';
           wait for c_period/2;  
           clk_12meg <= '1';
           wait for c_period/2;  
    end process;
    
    process
        begin
            wait for (1/4)*c_period;
            reset <= '1';
            wait for (3/4)*c_period;
            reset <= '0';
            wait for c_period;
            BTNL <= '1';
            sample_out_ready_audio <= '1';
            wait for 8*c_period;
            reset <= '0';
            BTNL <= '0'; 
            BTNR <= '1';
            wait for 8*c_period;
            reset <= '1';
            wait for 8*c_period;
            reset <= '0';
            wait;
            
    end process;

end Behavioral;