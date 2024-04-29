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
        
        if rst = '1' then
            DOUT_VLD <= '0';          
            DOUT <= (others => '0');  
            action_counter <= (others => '0'); 
            bit_counter <= (others => '0');        

        elsif rising_edge(clk) then

            if clock_active = '0' then 
                action_counter <= (others => '0'); 
            else  
                action_counter <= action_counter + 1; 
            end if;

            DOUT_VLD <= '0'; 

            if bit_counter = "1000" then 
                if validating_data = '1' then 
                    bit_counter <= (others => '0');
                    DOUT_VLD <= '1'; 
                end if;
            end if;

            if receiving_data = '1' then 
                if action_counter >= "01111" then 
                    action_counter <= (others => '0');

                    for i in DOUT'range loop
                        if bit_counter = to_unsigned(i, 4) then
                            DOUT(i) <= din;
                            bit_counter <= bit_counter + 1;
                            exit;  -- Exit loop after setting the corresponding bit
                        end if;
                    end loop;
                    
                    -- case bit_counter is
                    --     when '0' => 
                    --         DOUT(0) <= din;    
                    --         bit_counter <= bit_counter + 1; 
                    --     when "0001" => 
                    --         DOUT(1) <= din;    
                    --         bit_counter <= bit_counter + 1; 
                    --     when "0010" => 
                    --         DOUT(2) <= din;    
                    --         bit_counter <= bit_counter + 1; 
                    --     when "0011" => 
                    --         DOUT(3) <= din;    
                    --         bit_counter <= bit_counter + 1; 
                    --     when "0100" => 
                    --         DOUT(4) <= din;    
                    --         bit_counter <= bit_counter + 1; 
                    --     when "0101" => 
                    --         DOUT(5) <= din;    
                    --         bit_counter <= bit_counter + 1; 
                    --     when "0110" => 
                    --         DOUT(6) <= din;    
                    --         bit_counter <= bit_counter + 1; 
                    --     when "0111" => 
                    --         DOUT(7) <= din;    
                    --         bit_counter <= bit_counter + 1;
                    --     when others => null;   
                    --end case;
                
                end if;
            end if;
        end if;
    end process; 
end architecture;
