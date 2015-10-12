----------------------------------------------------------------------------------
-- Written by: Robin Janssens, Jens Donckers & Rudi Conings
-- Commissioned by: University of Antwerp
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( clk    : in     STD_LOGIC;
           clr    : in     STD_LOGIC;
           en     : in     STD_LOGIC;
           analog : in     STD_LOGIC_VECTOR (15 downto 0);
           sda    : inout  STD_LOGIC;
           scl    : inout  STD_LOGIC;
           Led    : out    STD_LOGIC_VECTOR (7 downto 0));
end main;

ARCHITECTURE Behavioral of main is

  -- =============================
  -- Signals
  -- =============================
  type    state is (state1, state2, state3, state4, state5);
  signal  present_state, next_state : state;
  -- ultrasonic_sensor
  signal  ultrasonic_sensor_rw       : STD_LOGIC;
  signal  ultrasonic_sensor_data_in  : STD_LOGIC_VECTOR (7 DOWNTO 0);
  signal  ultrasonic_sensor_data_out : STD_LOGIC_VECTOR (7 DOWNTO 0);
  signal  ultrasonic_sensor_busy     : STD_LOGIC;
  signal  ultrasonic_sensor_error    : STD_LOGIC;
  -- Blink
  signal  counter : integer range 0 to 25_000_000;
  signal  sec     : STD_LOGIC;

  -- =============================
  -- Components
  -- =============================
  component i2c_master
    GENERIC(
      input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
      bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
    PORT(
      clk       : IN     STD_LOGIC;                     --system clock
      reset_n   : IN     STD_LOGIC;                     --active low reset
      ena       : IN     STD_LOGIC;                     --latch in command
      addr      : IN     STD_LOGIC_VECTOR (6 DOWNTO 0); --address of target slave
      rw        : IN     STD_LOGIC;                     --'0' is write, '1' is read
      data_wr   : IN     STD_LOGIC_VECTOR (7 DOWNTO 0); --data to write to slave
      busy      : OUT    STD_LOGIC;                     --indicates transaction in progress
      data_rd   : OUT    STD_LOGIC_VECTOR (7 DOWNTO 0); --data read from slave
      ack_error : BUFFER STD_LOGIC;                     --flag if improper acknowledge from slave
      sda       : INOUT  STD_LOGIC;                     --serial data output of i2c bus
      scl       : INOUT  STD_LOGIC);                    --serial clock output of i2c bus
  end component;

BEGIN

  -- =============================
  -- Port Mappings
  -- =============================
  ultrasonic_sensor : i2c_master
    PORT MAP(
      clk       => clk,
      reset_n   => clr,
      ena       => en,
      addr      => "0000001",   -- addr = 1
      rw        => ultrasonic_sensor_rw,
      data_wr   => ultrasonic_sensor_data_out,
      busy      => ultrasonic_sensor_busy,
      data_rd   => ultrasonic_sensor_data_in,
      ack_error => ultrasonic_sensor_error,
      sda       => sda,
      scl       => scl);

  -- =============================
  -- Main Code
  -- =============================
  main: process (present_state) --, inputs)
  begin
    case present_state is
      when state1 =>
        -- code
      when state2 =>
        -- code
      when state3 =>
        -- code
      when state4 =>
        -- code
      when state5 =>
        -- code
      when others =>
        next_state <= state1;
    end case;
  end process;

  -- =============================
  -- State Change
  -- =============================
  state_change: process (clk)
  begin
    if rising_edge(clk) then
      if clr = '1' then
        present_state <= state1;
      else
        present_state <= next_state;
      end if;
    end if;
  end process;

  -- =============================
  -- Blink
  -- =============================
  secondsclk: process (clk)
  begin
    if rising_edge(clk) then
      if clr = '1' then
				sec <= '0';
			elsif en = '1' then
        if counter < 25_000_000 then
          counter <= counter + 1;
        else
          counter <= 0;
          sec <= not(sec);
        end if;
      end if;
    end if;
  end process;
  Led(0) <= '1';
  Led(1) <= '1';
  Led(2) <= '1';
  Led(3) <= '1';
  Led(4) <= '1';
  Led(5) <= '1';
  Led(6) <= '1';
  Led(7) <= sec;



END Behavioral;
