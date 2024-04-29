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
    first_bit_mid : in std_logic_vector (4 downto 0);
    next_bit_clock : in std_logic_vector (3 downto 0);
    bit_count : in std_logic_vector (2 downto 0);
    clock_active : out std_logic;
    data_receiving : out std_logic;
    data_valid : out std_logic);
end entity uart_rx_fsm;

architecture rtl of uart_rx_fsm is
  signal state : std_logic_vector (2 downto 0);
  signal n112_o : std_logic;
  signal n114_o : std_logic;
  signal n115_o : std_logic;
  signal n116_o : std_logic;
  signal n120_o : std_logic;
  signal n121_o : std_logic;
  signal n125_o : std_logic;
  signal n126_o : std_logic;
  signal n130_o : std_logic;
  signal n131_o : std_logic;
  signal n133_o : std_logic_vector (2 downto 0);
  signal n135_o : std_logic;
  signal n137_o : std_logic;
  signal n139_o : std_logic_vector (2 downto 0);
  signal n141_o : std_logic;
  signal n143_o : std_logic;
  signal n145_o : std_logic_vector (2 downto 0);
  signal n147_o : std_logic;
  signal n149_o : std_logic;
  signal n151_o : std_logic_vector (2 downto 0);
  signal n152_o : std_logic;
  signal n154_o : std_logic;
  signal n156_o : std_logic;
  signal n157_o : std_logic_vector (4 downto 0);
  signal n160_o : std_logic_vector (2 downto 0);
  signal n165_q : std_logic_vector (2 downto 0) := "000";
begin
  clock_active <= n116_o;
  data_receiving <= n121_o;
  data_valid <= n126_o;
  -- uart_rx_fsm.vhd:26:12
  state <= n165_q; -- (isignal)
  -- uart_rx_fsm.vhd:29:36
  n112_o <= '1' when state = "000" else '0';
  -- uart_rx_fsm.vhd:29:52
  n114_o <= '1' when state = "100" else '0';
  -- uart_rx_fsm.vhd:29:43
  n115_o <= n112_o or n114_o;
  -- uart_rx_fsm.vhd:29:25
  n116_o <= '1' when n115_o = '0' else '0';
  -- uart_rx_fsm.vhd:30:38
  n120_o <= '1' when state = "010" else '0';
  -- uart_rx_fsm.vhd:30:27
  n121_o <= '0' when n120_o = '0' else '1';
  -- uart_rx_fsm.vhd:31:34
  n125_o <= '1' when state = "100" else '0';
  -- uart_rx_fsm.vhd:31:23
  n126_o <= '0' when n125_o = '0' else '1';
  -- uart_rx_fsm.vhd:36:15
  n130_o <= '1' when rising_edge (clk) else '0';
  -- uart_rx_fsm.vhd:39:28
  n131_o <= not din;
  -- uart_rx_fsm.vhd:39:21
  n133_o <= state when n131_o = '0' else "001";
  -- uart_rx_fsm.vhd:38:17
  n135_o <= '1' when state = "000" else '0';
  -- uart_rx_fsm.vhd:43:38
  n137_o <= '1' when first_bit_mid = "10111" else '0';
  -- uart_rx_fsm.vhd:43:21
  n139_o <= state when n137_o = '0' else "010";
  -- uart_rx_fsm.vhd:42:17
  n141_o <= '1' when state = "001" else '0';
  -- uart_rx_fsm.vhd:47:34
  n143_o <= '1' when bit_count = "111" else '0';
  -- uart_rx_fsm.vhd:47:21
  n145_o <= state when n143_o = '0' else "011";
  -- uart_rx_fsm.vhd:46:17
  n147_o <= '1' when state = "010" else '0';
  -- uart_rx_fsm.vhd:52:43
  n149_o <= '1' when next_bit_clock = "1111" else '0';
  -- uart_rx_fsm.vhd:51:21
  n151_o <= state when n152_o = '0' else "100";
  -- uart_rx_fsm.vhd:51:21
  n152_o <= din and n149_o;
  -- uart_rx_fsm.vhd:50:17
  n154_o <= '1' when state = "011" else '0';
  -- uart_rx_fsm.vhd:56:17
  n156_o <= '1' when state = "100" else '0';
  n157_o <= n156_o & n154_o & n147_o & n141_o & n135_o;
  -- uart_rx_fsm.vhd:37:13
  with n157_o select n160_o <=
    "000" when "10000",
    n151_o when "01000",
    n145_o when "00100",
    n139_o when "00010",
    n133_o when "00001",
    "XXX" when others;
  -- uart_rx_fsm.vhd:36:9
  process (clk, rst)
  begin
    if rst = '1' then
      n165_q <= "000";
    elsif rising_edge (clk) then
      n165_q <= n160_o;
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
  signal first_bit_mid : std_logic_vector (4 downto 0);
  signal next_bit_clock : std_logic_vector (3 downto 0);
  signal bit_count : std_logic_vector (2 downto 0);
  signal clock_active : std_logic;
  signal data_receiving : std_logic;
  signal data_valid : std_logic;
  signal fsm_clock_active : std_logic;
  signal fsm_data_receiving : std_logic;
  signal fsm_data_valid : std_logic;
  signal n13_o : std_logic;
  signal n14_o : std_logic;
  signal n16_o : std_logic_vector (4 downto 0);
  signal n18_o : std_logic_vector (3 downto 0);
  signal n20_o : std_logic_vector (4 downto 0);
  signal n21_o : std_logic_vector (3 downto 0);
  signal n23_o : std_logic;
  signal n26_o : std_logic;
  signal n28_o : std_logic_vector (2 downto 0);
  signal n30_o : std_logic;
  signal n32_o : std_logic;
  signal n34_o : std_logic;
  signal n36_o : std_logic;
  signal n38_o : std_logic;
  signal n40_o : std_logic;
  signal n42_o : std_logic;
  signal n44_o : std_logic;
  signal n46_o : std_logic;
  signal n48_o : std_logic;
  signal n50_o : std_logic;
  signal n51_o : std_logic_vector (7 downto 0);
  signal n52_o : std_logic;
  signal n53_o : std_logic;
  signal n54_o : std_logic;
  signal n55_o : std_logic;
  signal n56_o : std_logic;
  signal n57_o : std_logic;
  signal n58_o : std_logic;
  signal n59_o : std_logic;
  signal n60_o : std_logic;
  signal n61_o : std_logic;
  signal n62_o : std_logic;
  signal n63_o : std_logic;
  signal n64_o : std_logic;
  signal n65_o : std_logic;
  signal n66_o : std_logic;
  signal n67_o : std_logic;
  signal n75_o : std_logic_vector (2 downto 0);
  signal n76_o : std_logic_vector (7 downto 0);
  signal n79_o : std_logic_vector (3 downto 0);
  signal n80_o : std_logic_vector (2 downto 0);
  signal n81_o : std_logic;
  signal n82_o : std_logic;
  signal n83_o : std_logic;
  signal n100_o : std_logic_vector (7 downto 0);
  signal n101_q : std_logic_vector (7 downto 0);
  signal n102_q : std_logic;
  signal n103_q : std_logic_vector (4 downto 0) := "00000";
  signal n104_q : std_logic_vector (3 downto 0) := "0000";
  signal n105_q : std_logic_vector (2 downto 0) := "000";
begin
  wrap_clk <= clk;
  wrap_rst <= rst;
  wrap_din <= din;
  dout <= wrap_dout;
  dout_vld <= wrap_dout_vld;
  wrap_DOUT <= n101_q;
  wrap_DOUT_VLD <= n102_q;
  -- uart_rx.vhd:25:12
  first_bit_mid <= n103_q; -- (isignal)
  -- uart_rx.vhd:26:12
  next_bit_clock <= n104_q; -- (isignal)
  -- uart_rx.vhd:27:12
  bit_count <= n105_q; -- (isignal)
  -- uart_rx.vhd:28:12
  clock_active <= fsm_clock_active; -- (isignal)
  -- uart_rx.vhd:29:12
  data_receiving <= fsm_data_receiving; -- (isignal)
  -- uart_rx.vhd:30:12
  data_valid <= fsm_data_valid; -- (isignal)
  -- uart_rx.vhd:34:5
  fsm : entity work.uart_rx_fsm port map (
    clk => wrap_CLK,
    rst => wrap_RST,
    din => wrap_DIN,
    first_bit_mid => first_bit_mid,
    next_bit_clock => next_bit_clock,
    bit_count => bit_count,
    clock_active => fsm_clock_active,
    data_receiving => fsm_data_receiving,
    data_valid => fsm_data_valid);
  -- uart_rx.vhd:56:19
  n13_o <= '1' when rising_edge (wrap_CLK) else '0';
  -- uart_rx.vhd:58:33
  n14_o <= not clock_active;
  -- uart_rx.vhd:61:52
  n16_o <= std_logic_vector (unsigned (first_bit_mid) + unsigned'("00001"));
  -- uart_rx.vhd:62:54
  n18_o <= std_logic_vector (unsigned (next_bit_clock) + unsigned'("0001"));
  -- uart_rx.vhd:58:17
  n20_o <= n16_o when n14_o = '0' else "00000";
  -- uart_rx.vhd:58:17
  n21_o <= n18_o when n14_o = '0' else next_bit_clock;
  -- uart_rx.vhd:67:30
  n23_o <= '1' when bit_count = "111" else '0';
  -- uart_rx.vhd:68:21
  n26_o <= '0' when data_valid = '0' else '1';
  -- uart_rx.vhd:67:17
  n28_o <= bit_count when n32_o = '0' else "000";
  -- uart_rx.vhd:67:17
  n30_o <= '0' when n23_o = '0' else n26_o;
  -- uart_rx.vhd:67:17
  n32_o <= n23_o and data_valid;
  -- uart_rx.vhd:75:39
  n34_o <= '1' when unsigned (next_bit_clock) >= unsigned'("1111") else '0';
  -- uart_rx.vhd:79:25
  n36_o <= '1' when bit_count = "000" else '0';
  -- uart_rx.vhd:82:25
  n38_o <= '1' when bit_count = "001" else '0';
  -- uart_rx.vhd:85:25
  n40_o <= '1' when bit_count = "010" else '0';
  -- uart_rx.vhd:88:25
  n42_o <= '1' when bit_count = "011" else '0';
  -- uart_rx.vhd:91:25
  n44_o <= '1' when bit_count = "100" else '0';
  -- uart_rx.vhd:94:25
  n46_o <= '1' when bit_count = "101" else '0';
  -- uart_rx.vhd:97:25
  n48_o <= '1' when bit_count = "110" else '0';
  -- uart_rx.vhd:100:25
  n50_o <= '1' when bit_count = "111" else '0';
  n51_o <= n50_o & n48_o & n46_o & n44_o & n42_o & n40_o & n38_o & n36_o;
  n52_o <= n101_q (0);
  -- uart_rx.vhd:78:21
  with n51_o select n53_o <=
    n52_o when "10000000",
    n52_o when "01000000",
    n52_o when "00100000",
    n52_o when "00010000",
    n52_o when "00001000",
    n52_o when "00000100",
    n52_o when "00000010",
    wrap_DIN when "00000001",
    n52_o when others;
  n54_o <= n101_q (1);
  -- uart_rx.vhd:78:21
  with n51_o select n55_o <=
    n54_o when "10000000",
    n54_o when "01000000",
    n54_o when "00100000",
    n54_o when "00010000",
    n54_o when "00001000",
    n54_o when "00000100",
    wrap_DIN when "00000010",
    n54_o when "00000001",
    n54_o when others;
  n56_o <= n101_q (2);
  -- uart_rx.vhd:78:21
  with n51_o select n57_o <=
    n56_o when "10000000",
    n56_o when "01000000",
    n56_o when "00100000",
    n56_o when "00010000",
    n56_o when "00001000",
    wrap_DIN when "00000100",
    n56_o when "00000010",
    n56_o when "00000001",
    n56_o when others;
  n58_o <= n101_q (3);
  -- uart_rx.vhd:78:21
  with n51_o select n59_o <=
    n58_o when "10000000",
    n58_o when "01000000",
    n58_o when "00100000",
    n58_o when "00010000",
    wrap_DIN when "00001000",
    n58_o when "00000100",
    n58_o when "00000010",
    n58_o when "00000001",
    n58_o when others;
  n60_o <= n101_q (4);
  -- uart_rx.vhd:78:21
  with n51_o select n61_o <=
    n60_o when "10000000",
    n60_o when "01000000",
    n60_o when "00100000",
    wrap_DIN when "00010000",
    n60_o when "00001000",
    n60_o when "00000100",
    n60_o when "00000010",
    n60_o when "00000001",
    n60_o when others;
  n62_o <= n101_q (5);
  -- uart_rx.vhd:78:21
  with n51_o select n63_o <=
    n62_o when "10000000",
    n62_o when "01000000",
    wrap_DIN when "00100000",
    n62_o when "00010000",
    n62_o when "00001000",
    n62_o when "00000100",
    n62_o when "00000010",
    n62_o when "00000001",
    n62_o when others;
  n64_o <= n101_q (6);
  -- uart_rx.vhd:78:21
  with n51_o select n65_o <=
    n64_o when "10000000",
    wrap_DIN when "01000000",
    n64_o when "00100000",
    n64_o when "00010000",
    n64_o when "00001000",
    n64_o when "00000100",
    n64_o when "00000010",
    n64_o when "00000001",
    n64_o when others;
  n66_o <= n101_q (7);
  -- uart_rx.vhd:78:21
  with n51_o select n67_o <=
    wrap_DIN when "10000000",
    n66_o when "01000000",
    n66_o when "00100000",
    n66_o when "00010000",
    n66_o when "00001000",
    n66_o when "00000100",
    n66_o when "00000010",
    n66_o when "00000001",
    n66_o when others;
  -- uart_rx.vhd:78:21
  with n51_o select n75_o <=
    n28_o when "10000000",
    "111" when "01000000",
    "110" when "00100000",
    "101" when "00010000",
    "100" when "00001000",
    "011" when "00000100",
    "010" when "00000010",
    "001" when "00000001",
    n28_o when others;
  n76_o <= n67_o & n65_o & n63_o & n61_o & n59_o & n57_o & n55_o & n53_o;
  -- uart_rx.vhd:74:17
  n79_o <= n21_o when n82_o = '0' else "0000";
  -- uart_rx.vhd:74:17
  n80_o <= n28_o when n83_o = '0' else n75_o;
  -- uart_rx.vhd:74:17
  n81_o <= data_receiving and n34_o;
  -- uart_rx.vhd:74:17
  n82_o <= data_receiving and n34_o;
  -- uart_rx.vhd:74:17
  n83_o <= data_receiving and n34_o;
  -- uart_rx.vhd:74:17
  n100_o <= n101_q when n81_o = '0' else n76_o;
  -- uart_rx.vhd:56:13
  process (wrap_CLK, wrap_RST)
  begin
    if wrap_RST = '1' then
      n101_q <= "00000000";
    elsif rising_edge (wrap_CLK) then
      n101_q <= n100_o;
    end if;
  end process;
  -- uart_rx.vhd:56:13
  process (wrap_CLK, wrap_RST)
  begin
    if wrap_RST = '1' then
      n102_q <= '0';
    elsif rising_edge (wrap_CLK) then
      n102_q <= n30_o;
    end if;
  end process;
  -- uart_rx.vhd:56:13
  process (wrap_CLK, wrap_RST)
  begin
    if wrap_RST = '1' then
      n103_q <= "00000";
    elsif rising_edge (wrap_CLK) then
      n103_q <= n20_o;
    end if;
  end process;
  -- uart_rx.vhd:56:13
  process (wrap_CLK, wrap_RST)
  begin
    if wrap_RST = '1' then
      n104_q <= "0000";
    elsif rising_edge (wrap_CLK) then
      n104_q <= n79_o;
    end if;
  end process;
  -- uart_rx.vhd:56:13
  process (wrap_CLK, wrap_RST)
  begin
    if wrap_RST = '1' then
      n105_q <= "000";
    elsif rising_edge (wrap_CLK) then
      n105_q <= n80_o;
    end if;
  end process;
end rtl;
