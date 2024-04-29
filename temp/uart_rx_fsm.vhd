-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Rastislav Uhliar (xuhliar00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity UART_RX_FSM is
    port(
        CLK             : in std_logic;                     
        RST             : in std_logic;                     
        DIN             : in std_logic;                     
        ACTION_COUNTER  : in std_logic_vector(4 downto 0);  
        BIT_COUNTER     : in std_logic_vector(3 downto 0);
        FINAL_BIT       : in std_logic_vector(1 downto 0);
        CLOCK_ACTIVE    : out std_logic;
        VALIDATING_DATA : out std_logic;                 
        RECEIVING_DATA  : out std_logic                                       
     );
end entity;

architecture behavioral of UART_RX_FSM is
    type fsm_states is (IDLE, WAIT_FOR_BIT, READ_BIT, WAIT_STOP, VALIDATING);  
    signal cur_state : fsm_states := IDLE;  
begin


    CLOCK_ACTIVE <= '0' when cur_state = IDLE or cur_state = VALIDATING else '1'; 
    VALIDATING_DATA <= '1' when cur_state = VALIDATING else '0'; 
    RECEIVING_DATA <= '1' when cur_state = READ_BIT else '0'; 

    
    process(CLK) begin

        
        if RST = '1' then
            cur_state <= IDLE; 
            
        elsif rising_edge(CLK) then
   
            case cur_state is
                when IDLE => 
                    if DIN = '0' then 
                        cur_state <= WAIT_FOR_BIT; 
                    end if;
                when WAIT_FOR_BIT =>
                    if ACTION_COUNTER = "10110" then 
                        cur_state <= READ_BIT; 
                    end if;
                when READ_BIT =>
                  --  if BIT_COUNTER = "1000" then 
                    if FINAL_BIT = "11" then
                        cur_state <= WAIT_STOP; 
                    end if;
                when WAIT_STOP =>
                    if DIN = '1' then 
                        if ACTION_COUNTER = "01110" then 
                            cur_state <= VALIDATING; 
                        end if;
                    end if;
                when VALIDATING =>
                    cur_state <= IDLE; 
                when others => null; 
            end case;

        end if;
    end process;
end architecture;
