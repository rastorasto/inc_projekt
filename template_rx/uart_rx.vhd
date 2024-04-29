-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Name Surname (xlogin00)

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
    signal MIDDLE_BIT_CLOCK     : std_logic_vector(3 downto 0) := "0000";                        
    signal NEXT_BIT_CLOCK       : std_logic_vector(3 downto 0) := "0000"; 
    signal BIT_COUNT            : std_logic_vector(2 downto 0) := "000";
    signal CLOCK_ACTIVE         : std_logic := '0';     
    signal DATA_RECEIVING       : std_logic := '0';                         
    signal DATA_VALID           : std_logic := '0';                         
begin

    -- Instance of RX FSM
    fsm: entity work.UART_RX_FSM
    port map (
        CLK => CLK,
        RST => RST,
        MIDDLE_BIT_CLOCK => MIDDLE_BIT_CLOCK,
        NEXT_BIT_CLOCK => NEXT_BIT_CLOCK,
        BIT_COUNT => BIT_COUNT,
        CLOCK_ACTIVE => CLOCK_ACTIVE,
        DATA_RECEIVING => DATA_RECEIVING,
        DATA_VALID => DATA_VALID
    );

   -- DOUT <= (others => '0');
  --  DOUT_VLD <= '0';

        process (CLK) begin
            if RST = '1' then
                DOUT <= (others => '0');
                DOUT_VLD <= '0';
                MIDDLE_BIT_CLOCK <= "000";
                NEXT_BIT_CLOCK <= "0000";
                BIT_COUNT <= "000";

            elsif rising_edge(CLK) then
                if CLOCK_ACTIVE = '0' then
                    MIDDLE_BIT_CLOCK <= "000";
                else 
                    MIDDLE_BIT_CLOCK <= MIDDLE_BIT_CLOCK + 1;
                    if MIDDLE_BIT_CLOCK = "111" then
                        NEXT_BIT_CLOCK <= NEXT_BIT_CLOCK + 1;
                    end if;
                end if;
                
                DOUT_VLD <= '0';

                if BIT_COUNT = "111" then
                    if DATA_VALID = '1' then
                        BIT_COUNT <= "000";
                        DOUT_VLD <= '1';
                    end if;
                end if;

                if DATA_RECEIVING = '1' then
                    if NEXT_BIT_CLOCK >= "1111" then
                        NEXT_BIT_CLOCK <= "0000";
                        
                        if BIT_COUNT = "000" then
                            DOUT(0) <= DIN;
                            BIT_COUNT <= "001";
                        elsif BIT_COUNT = "001" then
                            DOUT(1) <= DIN;
                            BIT_COUNT <= "010";
                        elsif BIT_COUNT = "010" then
                            DOUT(2) <= DIN;
                            BIT_COUNT <= "011";
                        elsif BIT_COUNT = "011" then
                            DOUT(3) <= DIN;
                            BIT_COUNT <= "100"; then
                        elsif BIT_COUNT = "100" then
                            DOUT(4) <= DIN;
                            BIT_COUNT <= "101";
                        elsif BIT_COUNT = "101" then
                            DOUT(5) <= DIN;
                            BIT_COUNT <= "110";
                        elsif BIT_COUNT = "110" then
                            DOUT(6) <= DIN;
                            BIT_COUNT <= "111";
                        elsif BIT_COUNT = "111" then
                            DOUT(7) <= DIN;
                            BIT_COUNT <= "000";
                        end if;

                    end if;

            end if;
        end if;
    end process;
end architecture;
