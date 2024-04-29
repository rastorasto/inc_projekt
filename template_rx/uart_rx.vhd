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
    signal MIDDLE_BIT_CLOCK     : std_logic_vector(2 downto 0) := "000";                        
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
        DIN => DIN,
        MIDDLE_BIT_CLOCK => middle_bit_clock,
        NEXT_BIT_CLOCK => next_bit_clock,
        BIT_COUNT => bit_count,
        CLOCK_ACTIVE => clock_active,
        DATA_RECEIVING => data_receiving,
        DATA_VALID => data_valid
    );


        process (CLK) begin
            if RST = '1' then
                DOUT <= (others => '0');
                DOUT_VLD <= '0';
                middle_bit_clock <= "000";
                next_bit_clock <= "0000";
                bit_count <= "000";

            elsif rising_edge(CLK) then
                if clock_active = '0' then
                    middle_bit_clock <= "000";
                else 
                    middle_bit_clock <= middle_bit_clock + 1;
                    if middle_bit_clock = "111" then
                        next_bit_clock <= next_bit_clock + 1;
                    end if;
                end if;
                
                DOUT_VLD <= '0';

                if bit_count = "000" then
                    if data_valid = '1' then
                        DOUT_VLD <= '1';
                        bit_count <= "000";
                    end if;
                end if;

                if data_receiving = '1' then
                    if next_bit_clock >= "1111" then
                        next_bit_clock <= "0000";
                        
                    case bit_count is
                        when bit_count = "000" =>
                            DOUT(0) <= DIN;
                            bit_count <= "001";
                        when bit_count = "001" =>
                            DOUT(1) <= DIN;
                            bit_count <= "010";
                        when bit_count = "010" =>
                            DOUT(2) <= DIN;
                            bit_count <= "011";
                        when bit_count = "011" =>
                            DOUT(3) <= DIN;
                            bit_count <= "100";
                        when bit_count = "100" =>
                            DOUT(4) <= DIN;
                            bit_count <= "101";
                        when bit_count = "101" =>
                            DOUT(5) <= DIN;
                            bit_count <= "110";
                        when bit_count = "110" =>
                            DOUT(6) <= DIN;
                            bit_count <= "111";
                        when bit_count = "111" =>
                            DOUT(7) <= DIN;
                            bit_count <= "000";
                        when others => null;
                    end case;
                    end if;
            end if;
        end if;
    end process;
end architecture;
