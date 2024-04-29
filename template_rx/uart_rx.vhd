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
    signal ACTION_COUNTER        : std_logic_vector(4 downto 0) := "00000";                         
    signal BIT_COUNT            : std_logic_vector(3 downto 0) := "0000";
 --   signal DONE_BIT             : std_logic_vector(1 downto 0) := "00";
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
        ACTION_COUNTER => action_counter,
        BIT_COUNT => bit_count,
        CLOCK_ACTIVE => clock_active,
        DATA_RECEIVING => data_receiving,
        DATA_VALID => data_valid
      --  DONE_BIT => done_bit
    );


        process (CLK) begin
            if RST = '1' then
                DOUT <= (others => '0');
                DOUT_VLD <= '0';
                action_counter <= "00000";
                bit_count <= "0000";
            --    done_bit <= "00";

            elsif rising_edge(CLK) then

                if clock_active = '0' then
                    action_counter <= "00000";
                else
                    action_counter <= action_counter + 1;
                end if;
                
                DOUT_VLD <= '0';

                if bit_count = "1111" then
                    if data_valid = '1' then
                        DOUT_VLD <= '1';
                        bit_count <= "0000";
                    end if;
                end if;

                if data_receiving = '1' then
                    if action_counter = "10000" then
                        action_counter <= "00000";
                        
                        case bit_count is
                            when "0000" =>
                                DOUT(0) <= DIN;
                                bit_count <= "0001";
                            when "0001" =>
                                DOUT(1) <= DIN;
                                bit_count <= "0010";
                            when "0010" =>
                                DOUT(2) <= DIN;
                                bit_count <= "0011";
                            when "0011" =>
                                DOUT(3) <= DIN;
                                bit_count <= "0100";
                            when "0100" =>
                                DOUT(4) <= DIN;
                                bit_count <= "0101";
                            when "0101" =>
                                DOUT(5) <= DIN;
                                bit_count <= "0110";
                            when "0110" =>
                                DOUT(6) <= DIN;
                                bit_count <= "0111";
                            when "0111" =>
                                DOUT(7) <= DIN;
                                bit_count <= "1111";
                            when others => null;
                        end case;

                    end if;
            end if;
        end if;
    end process;
end architecture;
