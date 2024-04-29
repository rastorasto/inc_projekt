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
       MIDDLE_BIT_CLOCK : in std_logic_vector(2 downto 0); -- Prejde do polovice bitu
       NEXT_BIT_CLOCK : in std_logic_vector(3 downto 0); -- Pocka do polovice dalsieho bitu
       CLOCK_ACTIVE : out std_logic; -- Clock signal
       BIT_COUNT : in std_logic_vector(2 downto 0); -- Pocet bitov
       DATA_RECEIVING : out std_logic; -- Data receiving
       DATA_VALID : out std_logic -- Data valid
    );
end entity;

architecture behavioral of UART_RX_FSM is
    type state_type is (IDLE, WAIT_MID, DATA_BIT, WAIT_STOP_BIT, VALIDATE);
    signal state : state_type := IDLE;
begin

   --MIDDLE_BIT_CLOCK <= '0' when state = IDLE or state = VALIDATE else '1';
   -- NEXT_BIT_CLOCK <= '0' when state = IDLE or state = VALIDATE else '1';
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
                    if MIDDLE_BIT_CLOCK = "111" then
                        state <= DATA_BIT;
                    end if;
                when DATA_BIT =>
                    if NEXT_BIT_CLOCK = "1111" then
                        if BIT_COUNT = "111" then
                            state <= WAIT_STOP_BIT;
                        else
                            state <= DATA_BIT;
                        end if;
                    end if;
                when WAIT_STOP_BIT =>
                    if DIN = '1' then
                        if MIDDLE_BIT_CLOCK = "111" then
                            state <= VALIDATE;
                        end if;
                    end if;
                when VALIDATE =>
                    if DOUT_VLD = '1' then
                        state <= IDLE;
                    end if;
            end case;
        end if;
    end process;
end architecture;
