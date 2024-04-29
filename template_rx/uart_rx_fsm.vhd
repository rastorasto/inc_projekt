-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Rastislav Uhliar (xlogin00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity UART_RX_FSM is
    port(
       CLK : in std_logic;
       RST : in std_logic;
       DIN : in std_logic;
   --    DONE_BIT : in std_logic_vector(1 downto 0);                            -- Pocka na koniec prijatych dat
       ACTION_COUNTER : in std_logic_vector(4 downto 0);    -- Pocka do polovice prveho bitu
       CLOCK_ACTIVE : out std_logic;                       -- Aktivuje hodiny
       BIT_COUNT : in std_logic_vector(3 downto 0);        -- Pocitac bitov
       DATA_RECEIVING : out std_logic;                     -- Prijimanie dat
       DATA_VALID : out std_logic                          -- Validita prijatych dat
    );
end entity;

architecture behavioral of UART_RX_FSM is
    type state_type is (IDLE, WAIT_MID, DATA_BIT, WAIT_STOP_BIT, VALIDATE);
    signal state : state_type := IDLE;
begin

    CLOCK_ACTIVE <= '0' when state = IDLE or state = VALIDATE else '1';
    DATA_RECEIVING <= '1' when state = DATA_BIT else '0';
    DATA_VALID <= '1' when state = VALIDATE else '0';

    process(CLK) begin
        if RST = '1' then
            state <= IDLE;
        elsif rising_edge(CLK) then
            case state is
                when IDLE =>
                    if DIN = '0' then
                        state <= WAIT_MID;
                    end if;
                when WAIT_MID =>
                    if ACTION_COUNTER = "10111" then
                        state <= DATA_BIT;
                    end if;
                when DATA_BIT =>
                    if bit_count = "1111" then
                        state <= WAIT_STOP_BIT;
                    end if;
                when WAIT_STOP_BIT =>
                    if DIN = '1' then
                        if action_counter = "01111" then
                            state <= VALIDATE;
                        end if;
                    end if;
                when VALIDATE =>
                    state <= IDLE;
            end case;
        end if;
    end process;
end architecture;
