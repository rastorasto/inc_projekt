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
    signal clk_cycle_active     : std_logic := '0';                         
    signal bit_cnt              : std_logic_vector(3 downto 0) := "0000";   
    signal data_recieve_active  : std_logic := '0';                         
    signal data_validate_active : std_logic := '0';                         

begin
    fsm: entity work.UART_RX_FSM
    port map (
        CLK => CLK,
        RST => RST,
        DIN => DIN,
        ACTION_COUNTER => ACTION_COUNTER,
        CLK_CYCLE_ACTIVE => clk_cycle_active,
        BIT_CNT => bit_cnt,
        DATA_RECIEVE_ACTIVE => data_recieve_active,
        DATA_VALIDATE_ACTIVE => data_validate_active
    );

    
    process (CLK) begin
        
        
        if RST = '1' then
            DOUT_VLD <= '0';          
            DOUT <= (others => '0');  
            ACTION_COUNTER <= "00001"; 
            bit_cnt <= "0000";        

        
        elsif rising_edge(CLK) then

            if clk_cycle_active = '0' then 
                ACTION_COUNTER <= "00001"; 
            else  
                ACTION_COUNTER <= ACTION_COUNTER + 1; 
            end if;

            DOUT_VLD <= '0'; 

            if bit_cnt = "1000" then 
                if data_validate_active = '1' then 
                    bit_cnt <= "0000"; 
                    DOUT_VLD <= '1'; 
                end if;
            end if;

            if data_recieve_active = '1' then 
                if ACTION_COUNTER >= "10000" then 
                    ACTION_COUNTER <= "00001"; 

                    
                    case bit_cnt is
                        when "0000" => 
                            DOUT(0) <= DIN;    
                            bit_cnt <= "0001"; 
                        when "0001" => 
                            DOUT(1) <= DIN;    
                            bit_cnt <= "0010"; 
                        when "0010" => 
                            DOUT(2) <= DIN;    
                            bit_cnt <= "0011"; 
                        when "0011" => 
                            DOUT(3) <= DIN;    
                            bit_cnt <= "0100"; 
                        when "0100" => 
                            DOUT(4) <= DIN;    
                            bit_cnt <= "0101"; 
                        when "0101" => 
                            DOUT(5) <= DIN;    
                            bit_cnt <= "0110"; 
                        when "0110" => 
                            DOUT(6) <= DIN;    
                            bit_cnt <= "0111"; 
                        when "0111" => 
                            DOUT(7) <= DIN;    
                            bit_cnt <= "1000"; 
                        when others => null;   
                    end case;

                end if;
            end if;
        end if;
    end process; 
end architecture;
