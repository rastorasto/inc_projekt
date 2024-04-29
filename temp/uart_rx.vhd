-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Rastislav Uhliar (xuhliar00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
    port(
        CLK      : in std_logic;
        RST      : in std_logic;
        DIN      : in std_logic;
        DOUT     : out std_logic_vector(7 downto 0);
        DOUT_VLD : out std_logic
    );
end entity;



-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is
    signal ACTION_COUNTER        : std_logic_vector(4 downto 0) := "00001";  
    signal CLOCK_ACTIVE     : std_logic := '0';                         
    signal BIT_COUNTER              : std_logic_vector(3 downto 0) := "0000";   
    signal RECEIVING_DATA  : std_logic := '0';                         
    signal VALIDATING_DATA : std_logic := '0';                         

begin
    fsm: entity work.UART_RX_FSM
    port map (
        CLK => CLK,
        RST => RST,
        DIN => DIN,
        ACTION_COUNTER => ACTION_COUNTER,
        CLOCK_ACTIVE => CLOCK_ACTIVE,
        BIT_COUNTER => BIT_COUNTER,
        RECEIVING_DATA => RECEIVING_DATA,
        VALIDATING_DATA => VALIDATING_DATA
    );

    
    process (CLK) begin
        
        
        if RST = '1' then
            DOUT_VLD <= '0';          
            DOUT <= (others => '0');  
            ACTION_COUNTER <= "00001"; 
            BIT_COUNTER <= "0000";        

        
        elsif rising_edge(CLK) then

            if CLOCK_ACTIVE = '0' then 
                ACTION_COUNTER <= "00001"; 
            else  
                ACTION_COUNTER <= ACTION_COUNTER + 1; 
            end if;

            DOUT_VLD <= '0'; 

            if BIT_COUNTER = "1000" then 
                if VALIDATING_DATA = '1' then 
                    BIT_COUNTER <= "0000"; 
                    DOUT_VLD <= '1'; 
                end if;
            end if;

            if RECEIVING_DATA = '1' then 
                if ACTION_COUNTER >= "10000" then 
                    ACTION_COUNTER <= "00001"; 
                    case BIT_COUNTER is
                        when "0000" => 
                            DOUT(0) <= DIN;    
                            BIT_COUNTER <= "0001"; 
                        when "0001" => 
                            DOUT(1) <= DIN;    
                            BIT_COUNTER <= "0010"; 
                        when "0010" => 
                            DOUT(2) <= DIN;    
                            BIT_COUNTER <= "0011"; 
                        when "0011" => 
                            DOUT(3) <= DIN;    
                            BIT_COUNTER <= "0100"; 
                        when "0100" => 
                            DOUT(4) <= DIN;    
                            BIT_COUNTER <= "0101"; 
                        when "0101" => 
                            DOUT(5) <= DIN;    
                            BIT_COUNTER <= "0110"; 
                        when "0110" => 
                            DOUT(6) <= DIN;    
                            BIT_COUNTER <= "0111"; 
                        when "0111" => 
                            DOUT(7) <= DIN;    
                            BIT_COUNTER <= "1000";  
                    end case;
                end if;
            end if;
        end if;
    end process; 
end architecture;
