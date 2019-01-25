----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2018 12:31:16
-- Design Name: 
-- Module Name: controlller_system - Behavioral
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

entity controller_system is
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
end controller_system;

architecture Behavioral of controller_system is

-- Signals states statement
    type state_type is (idle, state_delete_audio, state_record_audio, state_record_audio_1, 
                        state_play_audio, state_play_audio_1, state_play_audio_2,
                        state_play_audio_invert, state_play_audio_invert_1, state_play_audio_invert_2, 
                        state_play_audio_filter, state_play_audio_filter_1, state_play_audio_filter_2, state_play_audio_filter_3);
    signal current_state, next_state : state_type;
    
-- Statement signals
    signal addr_RAM_reg, addr_RAM_next, addr_max_reg, addr_max_next  : std_logic_vector (18 downto 0) := (others => '0');
    constant MAX_RAM : std_logic_vector (18 downto 0) := "1000000000000000000";            -- Capacity of RAM: 524288 
    constant MIN_RAM : std_logic_vector (18 downto 0) := "0000000000000000000";            -- address 0 to RAM
    signal wait_RAM_reg, wait_RAM_next : std_logic_vector (1 downto 0) := "00";
    constant n_2 : std_logic_vector (1 downto 0) := "10";
    constant n_0 : std_logic_vector (1 downto 0) := "00";             
    
begin

-- State and Registers of data
    process (clk_12meg, reset)
        begin
            if rising_edge(clk_12meg) then
                if (reset = '1') then
                    current_state <= idle;
                    addr_RAM_reg <= (others => '0');
--                    addr_max_reg <= (others => '0');
                    wait_RAM_reg <= (others => '0');
                else
                    current_state <= next_state;
                    addr_RAM_reg <= addr_RAM_next;
                    addr_max_reg <= addr_max_next;
                    wait_RAM_reg <= wait_RAM_next;             
                end if;
            end if;
    end process;
    
-- FSMD
    process (current_state, addr_RAM_reg, addr_max_reg, sample_out_ready_audio, sample_request_audio, sample_out_ready_filter, wait_RAM_reg)
        begin
        -- Default values
            
            -- audio interface
            record_enable <= '0';
            play_enable <= '0';
            -- RAM
            enable_RAM <= '0';
            read_write_RAM <= "0";      -- READ
            -- Filter';
            enable_filter <= '0';
            
            addr_RAM_next <= addr_RAM_reg;
            addr_max_next <= addr_max_reg;
            
            wait_RAM_next <= wait_RAM_reg; 
            
        --Transition of state
            case current_state is
--------------------------------------------------------------STATE IDLE-------------------------------------------------------------------
                when idle =>
                    record_enable <= '0';
                    play_enable <= '0';
                    enable_RAM <= '0';
                    enable_filter <= '0';
--                    read_write_RAM <= "0";  -- READ
------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------STATE DELETE AUDIO---------------------------------------------------------
                when state_delete_audio =>
                    addr_RAM_next <= (others => '0');
                    addr_max_next <= (others => '0');
------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------STATE RECORD AUDIO---------------------------------------------------------
                when state_record_audio =>          -- this state wait for the data to be digitized
                    record_enable <= '1';
                    
                    
                when state_record_audio_1 =>       -- this state save the digitized data in memory
                    read_write_RAM <= "1";
                    enable_RAM <= '1';
                    record_enable <= '1';
                    addr_RAM_next <= std_logic_vector( unsigned(addr_RAM_reg) + 1);
                    addr_max_next <= std_logic_vector( unsigned(addr_max_reg) + 1);
                    
------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------STATE PLAY AUDIO---------------------------------------------------------
                when state_play_audio =>        -- this state wait a new data in of audio
                    read_write_RAM <= "0";
--                    enable_RAM <= '1';
                    addr_RAM_next <= (others => '0');
                    play_enable <= '1';
                    
                    
                when state_play_audio_1 =>       -- this state reproduces the digitized data 
                    read_write_RAM <= "0";
                    enable_RAM <= '1';
                    play_enable <= '1';
                    addr_RAM_next <= std_logic_vector( unsigned(addr_RAM_reg) + 1 );
                    
                    
                when state_play_audio_2 =>      -- this state wait a new data in of audio
                    play_enable <= '1';
------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------STATE PLAY AUDIO INVERT----------------------------------------------------
                when state_play_audio_invert =>         -- this state wait a new data in of audio
                    read_write_RAM <= "0";
                    enable_RAM <= '1';
                    addr_RAM_next <= addr_max_reg;
                    play_enable <= '1';
                    
                    
                when state_play_audio_invert_1 =>       -- this state reproduces all the recording upside down
                    read_write_RAM <= "0";
                    enable_RAM <= '1';
                    play_enable <= '1';
                    addr_RAM_next <= std_logic_vector( unsigned(addr_RAM_reg) - 1 );
                
                
                when state_play_audio_invert_2 =>       -- this state wait a new data in of audio
                    play_enable <= '1';
------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------STATE PLAY AUDIO FILTER LOW PASS---------------------------------------------
                when state_play_audio_filter =>             -- this state the RAM is pointed at the beginning of the recording
                    read_write_RAM <= "0";
                    enable_RAM <= '1';
                    addr_RAM_next <= MIN_RAM;
                    
                    wait_RAM_next <= std_logic_vector( unsigned(wait_RAM_reg) + 1 );
                    if (wait_RAM_reg = n_2) then
                        enable_filter <= '1';
                    else
                        enable_filter <= '0';
                    end if;
                
                
                when state_play_audio_filter_1 =>           -- this state wait a new data in of filter (data has been treated by the filter)
                    enable_filter <= '0';
                    enable_RAM <= '1';
                    wait_RAM_next <= n_0;
                    
                    
                when state_play_audio_filter_2 =>           -- this state wait a new data in of audio 
                    play_enable <= '1';
                    
                    
                when state_play_audio_filter_3 =>           -- this state reproduces everything recorded in the RAM
                    read_write_RAM <= "0";
                    enable_RAM <= '1';
                    
                    wait_RAM_next <= std_logic_vector( unsigned(wait_RAM_reg) + 1 );
                    if (wait_RAM_reg = n_2) then
                        enable_filter <= '1';
                    elsif (wait_RAM_reg = n_0) then
                        addr_RAM_next <= std_logic_vector( unsigned(addr_RAM_reg) + 1);
                    else
                        enable_filter <= '0';
                    end if;
------------------------------------------------------------------------------------------------------------------------------------------
            end case;
    end process;
    
    
    process (current_state, BTNC, BTNL, BTNR, SW1, SW0, addr_RAM_reg, addr_max_reg, sample_out_ready_audio, sample_request_audio,
                sample_out_ready_filter, wait_RAM_reg)
    begin
        
    --Transition of state
        case current_state is
--------------------------------------------------------------STATE IDLE-------------------------------------------------------------------
            when idle =>
                if (BTNC = '1') then
                    next_state <= state_delete_audio;                       -- go to state delete audio
                else 
                    if (BTNL = '1') then
                        next_state <= state_record_audio;                   -- go to state record audio
                    else 
                        if (BTNR = '1') then
                        
                            if ( (SW1 = '0') and (SW0 = '0') ) then
                                next_state <= state_play_audio;             -- go to state play audio
                            elsif ( (SW1 = '0') and (SW0 = '1') ) then
                                next_state <= state_play_audio_invert;      -- go to state play audio invert
                            elsif ( SW1 = '1' ) then
                                next_state <= state_play_audio_filter;      -- go to state play audio filter
                            else 
                                next_state <= idle;
                            end if;
                            
                        else
                            next_state <= idle;
                        end if;
                    end if;
               end if;
------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------STATE DELETE AUDIO---------------------------------------------------------
            when state_delete_audio =>
                next_state <= idle;
------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------STATE RECORD AUDIO---------------------------------------------------------
            when state_record_audio =>          -- this state wait for the data to be digitized
                if (BTNL = '1') then
                    if (addr_RAM_reg < MAX_RAM) then
                    
                        if (sample_out_ready_audio = '1') then
                            next_state <= state_record_audio_1; 
                        else
                            next_state <= state_record_audio;
                        end if;
                        
                    else
                        next_state <= idle;
                    end if;
                else
                    next_state <= idle;
                end if;
                
                
            when state_record_audio_1 =>       -- this state save the digitized data in memory
                if (BTNL = '1') then
                    if (sample_out_ready_audio = '1') then
                        next_state <= state_record_audio_1;
                    else
                        next_state <= state_record_audio;
                    end if;
                else
                    next_state <= idle;
                end if;
------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------STATE PLAY AUDIO---------------------------------------------------------
            when state_play_audio =>        -- this state wait a new data in of audio
                if (sample_request_audio = '1') then
                    next_state <= state_play_audio_1;
                else
                    next_state <= state_play_audio;
                end if;
                
                
            when state_play_audio_1 =>       -- this state reproduces the digitized data 
                if(addr_RAM_reg < addr_max_reg) then
                
                    if (sample_request_audio = '1') then
                        next_state <= state_play_audio_1;
                    else
                        next_state <= state_play_audio_2;
                    end if;
                    
                else
                    next_state <= idle; 
                end if;
                
                
            when state_play_audio_2 =>      -- this state wait a new data in of audio
                if (sample_request_audio = '1') then
                    next_state <= state_play_audio_1;
                else
                    next_state <= state_play_audio_2;
                end if;
------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------STATE PLAY AUDIO INVERT----------------------------------------------------
            when state_play_audio_invert =>         -- this state wait a new data in of audio
                if (sample_request_audio = '1') then
                    next_state <= state_play_audio_invert_1;
                else
                    next_state <= state_play_audio_invert;
                end if;
                
                
            when state_play_audio_invert_1 =>       -- this state reproduces all the recording upside down
                if(addr_RAM_reg <= MIN_RAM) then
                    next_state <= idle;
                    
                else
                    
                    if (sample_request_audio = '1') then
                        next_state <= state_play_audio_invert_1;
                    else
                        next_state <= state_play_audio_invert_2;
                    end if; 
                    
                end if;
            
            
            when state_play_audio_invert_2 =>       -- this state wait a new data in of audio
                if (sample_request_audio = '1') then
                    next_state <= state_play_audio_invert_1;
                else
                    next_state <= state_play_audio_invert_2;
                end if;
------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------STATE PLAY AUDIO FILTER LOW PASS---------------------------------------------
            when state_play_audio_filter =>             -- this state the RAM is pointed at the beginning of the recording
                if(wait_RAM_reg = n_2)then
                    next_state <= state_play_audio_filter_1;
                else
                    next_state <= state_play_audio_filter;
                end if;
            
            
            when state_play_audio_filter_1 =>           -- this state wait a new data in of filter (data has been treated by the filter)                    
                if (sample_out_ready_filter = '1') then
                    next_state <= state_play_audio_filter_2;
                else
                    next_state <= state_play_audio_filter_1;
                end if;
                
                
            when state_play_audio_filter_2 =>           -- this state wait a new data in of audio
                if (sample_request_audio = '1') then
                    next_state <= state_play_audio_filter_3;
                else
                    next_state <= state_play_audio_filter_2;
                end if;
                
                
            when state_play_audio_filter_3 =>           -- this state reproduces everything recorded in the RAM
                if (addr_RAM_reg < addr_max_reg) then
                    if(wait_RAM_reg = n_2)then
                        next_state <= state_play_audio_filter_1;
                    else
                        next_state <= state_play_audio_filter_3;
                    end if;
                else
                    next_state <= idle;
                end if;
------------------------------------------------------------------------------------------------------------------------------------------
        end case;
    end process;
    
    addr_RAM <= addr_RAM_reg;
    
end Behavioral;
