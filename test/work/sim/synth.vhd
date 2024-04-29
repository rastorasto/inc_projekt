library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity UART_RX is
  port (
    CLK: in std_logic;
    RST: in std_logic;
    DIN: in std_logic;
    DOUT: out std_logic_vector (7 downto 0);
    DOUT_VLD: out std_logic
  );
end entity;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx_fsm is
  port (
    clk : in std_logic;
    rst : in std_logic;
    din : in std_logic;
    action_counter : in std_logic_vector (4 downto 0);
    bit_counter : in std_logic_vector (3 downto 0);
    clock_active : out std_logic;
    validating_data : out std_logic;
    receiving_data : out std_logic);
end entity uart_rx_fsm;

architecture rtl of uart_rx_fsm is
  signal cur_state : std_logic_vector (2 downto 0);
  signal n225_o : std_logic;
  signal n227_o : std_logic;
  signal n228_o : std_logic;
  signal n229_o : std_logic;
  signal n233_o : std_logic;
  signal n234_o : std_logic;
  signal n238_o : std_logic;
  signal n239_o : std_logic;
  signal n243_o : std_logic;
  signal n244_o : std_logic;
  signal n246_o : std_logic_vector (2 downto 0);
  signal n248_o : std_logic;
  signal n250_o : std_logic;
  signal n252_o : std_logic_vector (2 downto 0);
  signal n254_o : std_logic;
  signal n256_o : std_logic;
  signal n258_o : std_logic_vector (2 downto 0);
  signal n260_o : std_logic;
  signal n262_o : std_logic;
  signal n263_o : std_logic;
  signal n265_o : std_logic_vector (2 downto 0);
  signal n267_o : std_logic;
  signal n269_o : std_logic;
  signal n270_o : std_logic_vector (4 downto 0);
  signal n272_o : std_logic_vector (2 downto 0);
  signal n277_q : std_logic_vector (2 downto 0) := "000";
begin
  clock_active <= n229_o;
  validating_data <= n234_o;
  receiving_data <= n239_o;
  -- work/uart_rx_fsm.vhd:24:12
  cur_state <= n277_q; -- (isignal)
  -- work/uart_rx_fsm.vhd:28:40
  n225_o <= '1' when cur_state = "000" else '0';
  -- work/uart_rx_fsm.vhd:28:60
  n227_o <= '1' when cur_state = "100" else '0';
  -- work/uart_rx_fsm.vhd:28:47
  n228_o <= n225_o or n227_o;
  -- work/uart_rx_fsm.vhd:28:25
  n229_o <= '1' when n228_o = '0' else '0';
  -- work/uart_rx_fsm.vhd:29:43
  n233_o <= '1' when cur_state = "100" else '0';
  -- work/uart_rx_fsm.vhd:29:28
  n234_o <= '0' when n233_o = '0' else '1';
  -- work/uart_rx_fsm.vhd:30:42
  n238_o <= '1' when cur_state = "010" else '0';
  -- work/uart_rx_fsm.vhd:30:27
  n239_o <= '0' when n238_o = '0' else '1';
  -- work/uart_rx_fsm.vhd:39:15
  n243_o <= '1' when rising_edge (clk) else '0';
  -- work/uart_rx_fsm.vhd:43:28
  n244_o <= not din;
  -- work/uart_rx_fsm.vhd:43:21
  n246_o <= cur_state when n244_o = '0' else "001";
  -- work/uart_rx_fsm.vhd:42:17
  n248_o <= '1' when cur_state = "000" else '0';
  -- work/uart_rx_fsm.vhd:47:39
  n250_o <= '1' when action_counter = "10110" else '0';
  -- work/uart_rx_fsm.vhd:47:21
  n252_o <= cur_state when n250_o = '0' else "010";
  -- work/uart_rx_fsm.vhd:46:17
  n254_o <= '1' when cur_state = "001" else '0';
  -- work/uart_rx_fsm.vhd:51:36
  n256_o <= '1' when bit_counter = "1000" else '0';
  -- work/uart_rx_fsm.vhd:51:21
  n258_o <= cur_state when n256_o = '0' else "011";
  -- work/uart_rx_fsm.vhd:50:17
  n260_o <= '1' when cur_state = "010" else '0';
  -- work/uart_rx_fsm.vhd:55:53
  n262_o <= '1' when action_counter = "01110" else '0';
  -- work/uart_rx_fsm.vhd:55:34
  n263_o <= din and n262_o;
  -- work/uart_rx_fsm.vhd:55:21
  n265_o <= cur_state when n263_o = '0' else "100";
  -- work/uart_rx_fsm.vhd:54:17
  n267_o <= '1' when cur_state = "011" else '0';
  -- work/uart_rx_fsm.vhd:58:17
  n269_o <= '1' when cur_state = "100" else '0';
  n270_o <= n269_o & n267_o & n260_o & n254_o & n248_o;
  -- work/uart_rx_fsm.vhd:41:13
  with n270_o select n272_o <=
    "000" when "10000",
    n265_o when "01000",
    n258_o when "00100",
    n252_o when "00010",
    n246_o when "00001",
    cur_state when others;
  -- work/uart_rx_fsm.vhd:39:9
  process (clk, rst)
  begin
    if rst = '1' then
      n277_q <= "000";
    elsif rising_edge (clk) then
      n277_q <= n272_o;
    end if;
  end process;
end rtl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of uart_rx is
  signal wrap_CLK: std_logic;
  signal wrap_RST: std_logic;
  signal wrap_DIN: std_logic;
  subtype typwrap_DOUT is std_logic_vector (7 downto 0);
  signal wrap_DOUT: typwrap_DOUT;
  signal wrap_DOUT_VLD: std_logic;
  signal action_counter : std_logic_vector (4 downto 0);
  signal bit_counter : std_logic_vector (3 downto 0);
  signal clock_active : std_logic;
  signal validating_data : std_logic;
  signal receiving_data : std_logic;
  signal fsm_clock_active : std_logic;
  signal fsm_validating_data : std_logic;
  signal fsm_receiving_data : std_logic;
  signal n12_o : std_logic;
  signal n13_o : std_logic;
  signal n15_o : std_logic_vector (4 downto 0);
  signal n17_o : std_logic_vector (4 downto 0);
  signal n19_o : std_logic;
  signal n22_o : std_logic;
  signal n24_o : std_logic_vector (3 downto 0);
  signal n26_o : std_logic;
  signal n28_o : std_logic;
  signal n30_o : std_logic;
  signal n33_o : std_logic;
  signal n35_o : std_logic_vector (3 downto 0);
  signal n36_o : std_logic;
  signal n37_o : std_logic;
  signal n38_o : std_logic_vector (3 downto 0);
  signal n44_o : std_logic;
  signal n47_o : std_logic;
  signal n48_o : std_logic;
  signal n49_o : std_logic;
  signal n51_o : std_logic_vector (3 downto 0);
  signal n52_o : std_logic_vector (3 downto 0);
  signal n56_o : std_logic;
  signal n58_o : std_logic;
  signal n59_o : std_logic;
  signal n61_o : std_logic;
  signal n63_o : std_logic;
  signal n64_o : std_logic;
  signal n66_o : std_logic;
  signal n68_o : std_logic;
  signal n69_o : std_logic;
  signal n70_o : std_logic;
  signal n72_o : std_logic_vector (3 downto 0);
  signal n73_o : std_logic_vector (3 downto 0);
  signal n77_o : std_logic;
  signal n79_o : std_logic;
  signal n80_o : std_logic;
  signal n82_o : std_logic;
  signal n84_o : std_logic;
  signal n85_o : std_logic;
  signal n87_o : std_logic;
  signal n89_o : std_logic;
  signal n90_o : std_logic;
  signal n91_o : std_logic;
  signal n93_o : std_logic_vector (3 downto 0);
  signal n94_o : std_logic_vector (3 downto 0);
  signal n98_o : std_logic;
  signal n100_o : std_logic;
  signal n101_o : std_logic;
  signal n103_o : std_logic;
  signal n105_o : std_logic;
  signal n106_o : std_logic;
  signal n108_o : std_logic;
  signal n110_o : std_logic;
  signal n111_o : std_logic;
  signal n112_o : std_logic;
  signal n114_o : std_logic_vector (3 downto 0);
  signal n115_o : std_logic_vector (3 downto 0);
  signal n119_o : std_logic;
  signal n121_o : std_logic;
  signal n122_o : std_logic;
  signal n124_o : std_logic;
  signal n126_o : std_logic;
  signal n127_o : std_logic;
  signal n129_o : std_logic;
  signal n131_o : std_logic;
  signal n132_o : std_logic;
  signal n133_o : std_logic;
  signal n135_o : std_logic_vector (3 downto 0);
  signal n136_o : std_logic_vector (3 downto 0);
  signal n140_o : std_logic;
  signal n142_o : std_logic;
  signal n143_o : std_logic;
  signal n145_o : std_logic;
  signal n147_o : std_logic;
  signal n148_o : std_logic;
  signal n150_o : std_logic;
  signal n152_o : std_logic;
  signal n153_o : std_logic;
  signal n154_o : std_logic;
  signal n156_o : std_logic_vector (3 downto 0);
  signal n157_o : std_logic_vector (3 downto 0);
  signal n161_o : std_logic;
  signal n163_o : std_logic;
  signal n164_o : std_logic;
  signal n166_o : std_logic;
  signal n168_o : std_logic;
  signal n169_o : std_logic;
  signal n171_o : std_logic;
  signal n173_o : std_logic;
  signal n174_o : std_logic;
  signal n175_o : std_logic;
  signal n177_o : std_logic_vector (3 downto 0);
  signal n178_o : std_logic_vector (3 downto 0);
  signal n184_o : std_logic;
  signal n185_o : std_logic;
  signal n189_o : std_logic;
  signal n190_o : std_logic;
  signal n193_o : std_logic_vector (7 downto 0);
  signal n196_o : std_logic_vector (4 downto 0);
  signal n197_o : std_logic_vector (3 downto 0);
  signal n198_o : std_logic;
  signal n199_o : std_logic;
  signal n200_o : std_logic;
  signal n214_o : std_logic_vector (7 downto 0);
  signal n215_q : std_logic_vector (7 downto 0);
  signal n216_q : std_logic;
  signal n217_q : std_logic_vector (4 downto 0) := "00000";
  signal n218_q : std_logic_vector (3 downto 0) := "0000";
begin
  wrap_clk <= clk;
  wrap_rst <= rst;
  wrap_din <= din;
  dout <= wrap_dout;
  dout_vld <= wrap_dout_vld;
  wrap_DOUT <= n215_q;
  wrap_DOUT_VLD <= n216_q;
  -- work/uart_rx.vhd:22:12
  action_counter <= n217_q; -- (isignal)
  -- work/uart_rx.vhd:23:12
  bit_counter <= n218_q; -- (isignal)
  -- work/uart_rx.vhd:24:12
  clock_active <= fsm_clock_active; -- (isignal)
  -- work/uart_rx.vhd:25:12
  validating_data <= fsm_validating_data; -- (isignal)
  -- work/uart_rx.vhd:26:12
  receiving_data <= fsm_receiving_data; -- (isignal)
  -- work/uart_rx.vhd:30:5
  fsm : entity work.uart_rx_fsm port map (
    clk => wrap_CLK,
    rst => wrap_RST,
    din => wrap_DIN,
    action_counter => action_counter,
    bit_counter => bit_counter,
    clock_active => fsm_clock_active,
    validating_data => fsm_validating_data,
    receiving_data => fsm_receiving_data);
  -- work/uart_rx.vhd:51:15
  n12_o <= '1' when rising_edge (wrap_CLK) else '0';
  -- work/uart_rx.vhd:53:29
  n13_o <= not clock_active;
  -- work/uart_rx.vhd:56:50
  n15_o <= std_logic_vector (unsigned (action_counter) + unsigned'("00001"));
  -- work/uart_rx.vhd:53:13
  n17_o <= n15_o when n13_o = '0' else "00000";
  -- work/uart_rx.vhd:61:28
  n19_o <= '1' when bit_counter = "1000" else '0';
  -- work/uart_rx.vhd:62:17
  n22_o <= '0' when validating_data = '0' else '1';
  -- work/uart_rx.vhd:61:13
  n24_o <= bit_counter when n28_o = '0' else "0000";
  -- work/uart_rx.vhd:61:13
  n26_o <= '0' when n19_o = '0' else n22_o;
  -- work/uart_rx.vhd:61:13
  n28_o <= n19_o and validating_data;
  -- work/uart_rx.vhd:69:35
  n30_o <= '1' when unsigned (action_counter) >= unsigned'("01111") else '0';
  -- work/uart_rx.vhd:73:40
  n33_o <= '1' when bit_counter = "0111" else '0';
  -- work/uart_rx.vhd:75:56
  n35_o <= std_logic_vector (unsigned (bit_counter) + unsigned'("0001"));
  n36_o <= n215_q (7);
  -- work/uart_rx.vhd:73:25
  n37_o <= n36_o when n33_o = '0' else wrap_DIN;
  -- work/uart_rx.vhd:73:25
  n38_o <= n24_o when n33_o = '0' else n35_o;
  -- work/uart_rx.vhd:73:25
  n44_o <= '1' when n33_o = '0' else '0';
  -- work/uart_rx.vhd:73:40
  n47_o <= '1' when bit_counter = "0110" else '0';
  n48_o <= n215_q (6);
  -- work/uart_rx.vhd:73:25
  n49_o <= n48_o when n63_o = '0' else wrap_DIN;
  -- work/uart_rx.vhd:75:56
  n51_o <= std_logic_vector (unsigned (bit_counter) + unsigned'("0001"));
  -- work/uart_rx.vhd:73:25
  n52_o <= n38_o when n64_o = '0' else n51_o;
  -- work/uart_rx.vhd:73:25
  n56_o <= n44_o when n66_o = '0' else '0';
  -- work/uart_rx.vhd:73:25
  n58_o <= n47_o and n44_o;
  -- work/uart_rx.vhd:73:25
  n59_o <= n47_o and n44_o;
  -- work/uart_rx.vhd:73:25
  n61_o <= n47_o and n44_o;
  -- work/uart_rx.vhd:73:25
  n63_o <= n44_o and n58_o;
  -- work/uart_rx.vhd:73:25
  n64_o <= n44_o and n59_o;
  -- work/uart_rx.vhd:73:25
  n66_o <= n44_o and n61_o;
  -- work/uart_rx.vhd:73:40
  n68_o <= '1' when bit_counter = "0101" else '0';
  n69_o <= n215_q (5);
  -- work/uart_rx.vhd:73:25
  n70_o <= n69_o when n84_o = '0' else wrap_DIN;
  -- work/uart_rx.vhd:75:56
  n72_o <= std_logic_vector (unsigned (bit_counter) + unsigned'("0001"));
  -- work/uart_rx.vhd:73:25
  n73_o <= n52_o when n85_o = '0' else n72_o;
  -- work/uart_rx.vhd:73:25
  n77_o <= n56_o when n87_o = '0' else '0';
  -- work/uart_rx.vhd:73:25
  n79_o <= n68_o and n56_o;
  -- work/uart_rx.vhd:73:25
  n80_o <= n68_o and n56_o;
  -- work/uart_rx.vhd:73:25
  n82_o <= n68_o and n56_o;
  -- work/uart_rx.vhd:73:25
  n84_o <= n56_o and n79_o;
  -- work/uart_rx.vhd:73:25
  n85_o <= n56_o and n80_o;
  -- work/uart_rx.vhd:73:25
  n87_o <= n56_o and n82_o;
  -- work/uart_rx.vhd:73:40
  n89_o <= '1' when bit_counter = "0100" else '0';
  n90_o <= n215_q (4);
  -- work/uart_rx.vhd:73:25
  n91_o <= n90_o when n105_o = '0' else wrap_DIN;
  -- work/uart_rx.vhd:75:56
  n93_o <= std_logic_vector (unsigned (bit_counter) + unsigned'("0001"));
  -- work/uart_rx.vhd:73:25
  n94_o <= n73_o when n106_o = '0' else n93_o;
  -- work/uart_rx.vhd:73:25
  n98_o <= n77_o when n108_o = '0' else '0';
  -- work/uart_rx.vhd:73:25
  n100_o <= n89_o and n77_o;
  -- work/uart_rx.vhd:73:25
  n101_o <= n89_o and n77_o;
  -- work/uart_rx.vhd:73:25
  n103_o <= n89_o and n77_o;
  -- work/uart_rx.vhd:73:25
  n105_o <= n77_o and n100_o;
  -- work/uart_rx.vhd:73:25
  n106_o <= n77_o and n101_o;
  -- work/uart_rx.vhd:73:25
  n108_o <= n77_o and n103_o;
  -- work/uart_rx.vhd:73:40
  n110_o <= '1' when bit_counter = "0011" else '0';
  n111_o <= n215_q (3);
  -- work/uart_rx.vhd:73:25
  n112_o <= n111_o when n126_o = '0' else wrap_DIN;
  -- work/uart_rx.vhd:75:56
  n114_o <= std_logic_vector (unsigned (bit_counter) + unsigned'("0001"));
  -- work/uart_rx.vhd:73:25
  n115_o <= n94_o when n127_o = '0' else n114_o;
  -- work/uart_rx.vhd:73:25
  n119_o <= n98_o when n129_o = '0' else '0';
  -- work/uart_rx.vhd:73:25
  n121_o <= n110_o and n98_o;
  -- work/uart_rx.vhd:73:25
  n122_o <= n110_o and n98_o;
  -- work/uart_rx.vhd:73:25
  n124_o <= n110_o and n98_o;
  -- work/uart_rx.vhd:73:25
  n126_o <= n98_o and n121_o;
  -- work/uart_rx.vhd:73:25
  n127_o <= n98_o and n122_o;
  -- work/uart_rx.vhd:73:25
  n129_o <= n98_o and n124_o;
  -- work/uart_rx.vhd:73:40
  n131_o <= '1' when bit_counter = "0010" else '0';
  n132_o <= n215_q (2);
  -- work/uart_rx.vhd:73:25
  n133_o <= n132_o when n147_o = '0' else wrap_DIN;
  -- work/uart_rx.vhd:75:56
  n135_o <= std_logic_vector (unsigned (bit_counter) + unsigned'("0001"));
  -- work/uart_rx.vhd:73:25
  n136_o <= n115_o when n148_o = '0' else n135_o;
  -- work/uart_rx.vhd:73:25
  n140_o <= n119_o when n150_o = '0' else '0';
  -- work/uart_rx.vhd:73:25
  n142_o <= n131_o and n119_o;
  -- work/uart_rx.vhd:73:25
  n143_o <= n131_o and n119_o;
  -- work/uart_rx.vhd:73:25
  n145_o <= n131_o and n119_o;
  -- work/uart_rx.vhd:73:25
  n147_o <= n119_o and n142_o;
  -- work/uart_rx.vhd:73:25
  n148_o <= n119_o and n143_o;
  -- work/uart_rx.vhd:73:25
  n150_o <= n119_o and n145_o;
  -- work/uart_rx.vhd:73:40
  n152_o <= '1' when bit_counter = "0001" else '0';
  n153_o <= n215_q (1);
  -- work/uart_rx.vhd:73:25
  n154_o <= n153_o when n168_o = '0' else wrap_DIN;
  -- work/uart_rx.vhd:75:56
  n156_o <= std_logic_vector (unsigned (bit_counter) + unsigned'("0001"));
  -- work/uart_rx.vhd:73:25
  n157_o <= n136_o when n169_o = '0' else n156_o;
  -- work/uart_rx.vhd:73:25
  n161_o <= n140_o when n171_o = '0' else '0';
  -- work/uart_rx.vhd:73:25
  n163_o <= n152_o and n140_o;
  -- work/uart_rx.vhd:73:25
  n164_o <= n152_o and n140_o;
  -- work/uart_rx.vhd:73:25
  n166_o <= n152_o and n140_o;
  -- work/uart_rx.vhd:73:25
  n168_o <= n140_o and n163_o;
  -- work/uart_rx.vhd:73:25
  n169_o <= n140_o and n164_o;
  -- work/uart_rx.vhd:73:25
  n171_o <= n140_o and n166_o;
  -- work/uart_rx.vhd:73:40
  n173_o <= '1' when bit_counter = "0000" else '0';
  n174_o <= n215_q (0);
  -- work/uart_rx.vhd:73:25
  n175_o <= n174_o when n189_o = '0' else wrap_DIN;
  -- work/uart_rx.vhd:75:56
  n177_o <= std_logic_vector (unsigned (bit_counter) + unsigned'("0001"));
  -- work/uart_rx.vhd:73:25
  n178_o <= n157_o when n190_o = '0' else n177_o;
  -- work/uart_rx.vhd:73:25
  n184_o <= n173_o and n161_o;
  -- work/uart_rx.vhd:73:25
  n185_o <= n173_o and n161_o;
  -- work/uart_rx.vhd:73:25
  n189_o <= n161_o and n184_o;
  -- work/uart_rx.vhd:73:25
  n190_o <= n161_o and n185_o;
  n193_o <= n37_o & n49_o & n70_o & n91_o & n112_o & n133_o & n154_o & n175_o;
  -- work/uart_rx.vhd:68:13
  n196_o <= n17_o when n199_o = '0' else "00000";
  -- work/uart_rx.vhd:68:13
  n197_o <= n24_o when n200_o = '0' else n178_o;
  -- work/uart_rx.vhd:68:13
  n198_o <= receiving_data and n30_o;
  -- work/uart_rx.vhd:68:13
  n199_o <= receiving_data and n30_o;
  -- work/uart_rx.vhd:68:13
  n200_o <= receiving_data and n30_o;
  -- work/uart_rx.vhd:68:13
  n214_o <= n215_q when n198_o = '0' else n193_o;
  -- work/uart_rx.vhd:51:9
  process (wrap_CLK, wrap_RST)
  begin
    if wrap_RST = '1' then
      n215_q <= "00000000";
    elsif rising_edge (wrap_CLK) then
      n215_q <= n214_o;
    end if;
  end process;
  -- work/uart_rx.vhd:51:9
  process (wrap_CLK, wrap_RST)
  begin
    if wrap_RST = '1' then
      n216_q <= '0';
    elsif rising_edge (wrap_CLK) then
      n216_q <= n26_o;
    end if;
  end process;
  -- work/uart_rx.vhd:51:9
  process (wrap_CLK, wrap_RST)
  begin
    if wrap_RST = '1' then
      n217_q <= "00000";
    elsif rising_edge (wrap_CLK) then
      n217_q <= n196_o;
    end if;
  end process;
  -- work/uart_rx.vhd:51:9
  process (wrap_CLK, wrap_RST)
  begin
    if wrap_RST = '1' then
      n218_q <= "0000";
    elsif rising_edge (wrap_CLK) then
      n218_q <= n197_o;
    end if;
  end process;
end rtl;
