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
    signal ACTION_COUNTER : std_logic_vector(4 downto 0) := (others => '0');
    signal BIT_COUNTER    : std_logic_vector(3 downto 0) := (others => '0'); 
    signal CLOCK_ACTIVE   : std_logic := '0'; 
    signal VALIDATING_DATA: std_logic := '0';                           
    signal RECEIVING_DATA : std_logic := '0';                                                 


begin
    fsm: entity work.UART_RX_FSM
    port map (
        CLK => clk,
        RST => rst,
        DIN => din,
        ACTION_COUNTER => action_counter,
        CLOCK_ACTIVE => clock_active,
        BIT_COUNTER => bit_counter,
        RECEIVING_DATA => receiving_data,
        VALIDATING_DATA => validating_data
    );

    
    process (clk) begin
        
        if rst = '1' then -- Ak pride reset nastavime hodnoty na nuly
            DOUT_VLD <= '0';          
            DOUT <= (others => '0');  
            action_counter <= (others => '0'); 
            bit_counter <= (others => '0');        

        elsif rising_edge(clk) then

            if clock_active = '0' then -- Ak je clock neaktivny nastavime hodiny na nulu
                action_counter <= (others => '0'); 
            else  
                action_counter <= action_counter + 1; -- Inak inkrementujeme hodiny
            end if;

            DOUT_VLD <= '0'; -- Nastavime vypis dat na nulu

            if bit_counter = "1000" then -- Ak som nacitali cele slovo
                if validating_data = '1' then -- A som v stave validacia
                    bit_counter <= (others => '0'); -- Nastavime hodiny na nulu
                    DOUT_VLD <= '1';                -- Vypiseme data
                end if;
            end if;

            if receiving_data = '1' then -- Ak som v stane prijimania dat
                if action_counter >= "01111" then -- A sme v strede bitu
                    action_counter <= (others => '0'); -- Nastavim hodiny na nulu aby som mohol pocitat dalsi stred

                    for i in DOUT'range loop -- Cez loop prejdem vsetky linie DOUT 
                        if bit_counter = i then -- Pre aktualny bit
                            DOUT(i) <= din; -- Nastavim hodnotu na DOUTovej linke
                            bit_counter <= bit_counter + 1; -- Inkrementujem pocitac aktualneho bitu
                            exit; -- Vyskocim z loopu
                        end if;
                    end loop;
                
                end if;
            end if;
        end if;
    end process; 
end architecture;
