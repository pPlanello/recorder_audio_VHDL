----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2018 21:42:28
-- Design Name: 
-- Module Name: ram_tb - Behavioral
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

entity ram_tb is
--  Port ( );
end ram_tb;

architecture Behavioral of ram_tb is

-- Declaration of component:
    component RAM is
                Port (
                    clka : in STD_LOGIC;
                    rsta : in STD_LOGIC;                            -- reset of RAM
                    ena : in STD_LOGIC;                             -- enable of RAM
                    wea : in STD_LOGIC_VECTOR ( 0 to 0 );           -- 1 to write and 0 to read
                    addra : in STD_LOGIC_VECTOR ( 18 downto 0 );    -- address where you shave the word
                    dina : in STD_LOGIC_VECTOR ( 7 downto 0 );      -- data in
                    douta : out STD_LOGIC_VECTOR ( 7 downto 0 )     -- data out
                );
    end component;

-- Declaration of signals:
    signal clka, ena, rsta : std_logic := '0';
    signal wea : std_logic_vector (0 to 0) := (others=>'0');
    signal addra : std_logic_vector (18 downto 0) := (others=>'0');
    signal dina, douta : std_logic_vector (7 downto 0) := (others=>'0');
    
    constant c_period : time := 83 ns;
    
begin

tst_RAM : RAM port map (
                        clka => clka,
                        rsta => rsta,
                        ena => ena,
                        wea => wea,
                        addra => addra,
                        dina => dina,
                        douta => douta
                    );

-- Process clk
    process
        begin
            clka <= '0';
            wait for c_period/2;
            clka <= '1';
            wait for c_period/2;
    end process;

-- Process test
    process
        begin
    -- RSTA to 1
            rsta <= '1';
        -- ENA to 0                    
            ena <= '0';
            wait for 3*c_period;
            wea(0) <= '1';              -- write
            dina <= "10010001";
            addra <= "0000000000000000001";
            wait for 3*c_period;
            wea(0) <= '0';              -- read
            addra <= "0000000000000000010";
        -- ENA to 1
            wait for 3*c_period;
            ena <= '1';
            wea(0) <= '0';              -- read
            addra <= "0000000000000000000";
            wait for 3*c_period;
            wea(0) <= '1';              -- write
            dina <= "00100101";
            addra <= "0000000000000000001";
            wait for 3*c_period;
            wea(0) <= '0';              -- read
            addra <= "0000000000000000010";
            wait for 3*c_period;
    -- RSTA to 0
       --  ENA to 0                
            ena <= '0';
            wait for c_period;
            rsta <= '0';
            wea (0) <= '0';             -- read
            addra <= "0000000000000000000";
            wait for 3*c_period;
            wea(0) <= '1';              -- write
            dina <= "00101001";
            addra <= "0000000000000000001";
            wait for 3*c_period;
            wea(0) <= '0';              -- read
            addra <= "0000000000000000010";
            wait for 3*c_period;
       -- ENA to 1
            ena <= '1';
            wea(0) <= '0';              -- read
            dina <= "10010000";
            addra <= "0000000000000000000";
            wait for 3*c_period;
            wea(0) <= '1';              -- write
            addra <= "0000000000000000001";
            wait for 3*c_period;
            wea(0) <= '0';              -- read
            dina <= "00101010";
            addra <= "0000000000000000001";
            wait for 3*c_period;
        -- test random:
            rsta <= '1';
            ena <= '1';
            wait for c_period;
            ena <= '0';
            wea(0) <= '1';
            dina <= "01101011";
            addra <= "0000000000000000000";
            wait for c_period;
            ena <= '1';
            dina <= "10000010";
            addra <= "0000000000000000001";
            wait for c_period;
            rsta <= '0';
            addra <= "0000000000000000011";
            wait for c_period;
            ena <= '0';
            dina <= "11011010";
            addra <= "0000000000000000010";
            wait for c_period;
            ena <= '1';
            wait for 3*c_period;
            wea(0) <= '0';
            addra <= "0000000000000000000";
            wait for c_period;
            addra <= "0000000000000000001";
            wait for c_period;
            ena <= '0';
            wait for c_period;
            addra <= "0000000000000000010";
            wait for c_period;
            addra <= "0000000000000000100";
            wait for 2*c_period;
            ena <= '0';
            rsta <= '1';
            addra <= "0000000000000000011";
            wait for 2*c_period;
            ena <= '1';
            
            wait;
    end process;

end Behavioral;
