----------------------------------------------------------------------------------
-- Written by: Robin Janssens, Jens Donckers & Rudi Conings
-- Commissioned by: University of Antwerp
-- Thanks to Scott Larson for sharing the i2c library
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
    Port ( clk    : in     STD_LOGIC;
           clr    : in     STD_LOGIC;
           en     : in     STD_LOGIC;
           Led    : inout    STD_LOGIC_VECTOR (7 downto 0);
           A      : inout  STD_LOGIC_VECTOR (3 downto 0);  -- to I2C master bus
           B      : inout  STD_LOGIC_VECTOR (3 downto 0);  -- to touch sensor
			  C      : inout  STD_LOGIC_VECTOR (3 downto 0); 
			  D      : inout  STD_LOGIC_VECTOR (3 downto 0); 
			  E      : inout  STD_LOGIC_VECTOR (3 downto 0); 
			  F      : inout  STD_LOGIC_VECTOR (3 downto 0));
end main;

ARCHITECTURE Behavioral of main is

  -- =============================
  -- Signals
  -- =============================
  type    state is (idle, state1, touch_sensor_check, state3, state4, state5);
  signal  present_state, next_state : state;
  -- RAM
  type ram is array(31 downto 0) of std_logic_vector(7 downto 0);	
  signal memory : ram;	
  -- I2C
  signal  i2c_ena             : STD_LOGIC;
  signal  i2c_addr            : STD_LOGIC_VECTOR (6 DOWNTO 0);
  signal  i2c_rw              : STD_LOGIC;
  signal  i2c_data_wr         : STD_LOGIC_VECTOR (7 DOWNTO 0);
  signal  i2c_busy            : STD_LOGIC;
  signal  i2c_data_rd         : STD_LOGIC_VECTOR (7 DOWNTO 0);
  signal  i2c_ack_error       : STD_LOGIC;
  signal  busy_prev           : STD_LOGIC;
  signal  slave_addr          : STD_LOGIC_VECTOR (6 DOWNTO 0);
  signal  data_to_write       : STD_LOGIC_VECTOR (7 DOWNTO 0);
  signal  new_data_to_write   : STD_LOGIC_VECTOR (7 DOWNTO 0);
  -- Blink
  signal  counter  : integer range 0 to 25_000_000;
  signal  sec      : STD_LOGIC;

  -- Touch sensor
  signal  touch    : STD_LOGIC;

  -- =============================
  -- Components
  -- =============================
  component i2c_master
    GENERIC(
      input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
      bus_clk   : INTEGER := 9_600);   --speed the i2c bus (scl) will run at in Hz
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

  component int_drukknop
    Port(
	   d_in     : in  STD_LOGIC;							  -- Hier moet de drukknop aan worden gehangen
      d_out    : out STD_LOGIC;							  -- Dit is de algemene uitgang van de interface
      press    : out STD_LOGIC;							  -- 1 Puls hoog bij het induwen van de knop
      release  : out STD_LOGIC;						     -- 1 Puls hoog bij het loslaten van de knop
      clk      : in  STD_LOGIC;							  -- De clock ingang
		waitTime : in  STD_LOGIC_VECTOR (7 downto 0)); -- De sensibilisering tijd tussen ingang en uitgang
  end component;

BEGIN

  -- =============================
  -- Port Mappings
  -- =============================
  i2c_master_bus : i2c_master
    PORT MAP(
      clk       => clk,
      reset_n   => not(clr),
      ena       => i2c_ena,
      addr      => i2c_addr,
      rw        => i2c_rw,
      data_wr   => i2c_data_wr,
      busy      => i2c_busy,
      data_rd   => i2c_data_rd,
      ack_error => i2c_ack_error,
      sda       => A(1),
      scl       => A(2));

	touch_sensor : int_drukknop
	  PORT MAP(
	    d_in     => B(3),
		 d_out    => touch,
		 clk      => clk,
		 waitTime => "00000100");

  -- =============================
  -- Code
  -- =============================
  
  -- Touch Sensor
  memory(0) <= "0000000" & touch;
  
  -- I2C Master
  i2c_read: process (i2c_busy, clr)
    variable busy_cnt            : integer range 0 to 4 := 0;
  begin
    slave_addr <= "0000010";       -- ultrasonic sensor adress = 2
    data_to_write <= "00000000";   -- get version info (returns 8 bit)
    new_data_to_write <= "00000011";   -- ??
 
    -- =============================
    -- Read Sensor I2C
    -- =============================
    busy_prev <= i2c_busy;                       -- capture previous i2c busy signal
	 if (clr = '1') then
	   busy_cnt := 0;
    elsif (busy_prev = '0' and i2c_busy = '1') then  -- i2c busy just went high
      busy_cnt := busy_cnt + 1;                  -- counts the times busy has gone from low to high during transaction
	 end if;
    case busy_cnt is                             -- busy_cnt keeps track of which command we are on
      when 0 =>                                  -- no command latched in yet
        i2c_ena <= '1';                          -- initiate the transaction
        i2c_addr <= slave_addr;                  -- set the address of the slave
        i2c_rw <= '0';                           -- command 1 is a write
        i2c_data_wr <= data_to_write;            -- data to be written
      when 1 =>                                  -- 1st busy high: command 1 latched, okay to issue command 2
        i2c_rw <= '1';                           -- command 2 is a read (addr stays the same)
      when 2 =>                                  -- 2nd busy high: command 2 latched, okay to issue command 3
        i2c_rw <= '0';                           -- command 3 is a write
        i2c_data_wr <= new_data_to_write;        -- data to be written
        if(i2c_busy = '0') then                  -- indicates data read in command 2 is ready
          memory(1) <= i2c_data_rd;              -- retrieve data from command 2
        end if;
      when 3 =>                                  -- 3rd busy high: command 3 latched, okay to issue command 4
        i2c_rw <= '1';                           -- command 4 is read (addr stays the same)
      when 4 =>                                  -- 4th busy high: command 4 latched, ready to stop
        i2c_ena <= '0';                          -- deassert enable to stop transaction after command 4
        if(i2c_busy = '0') then                  -- indicates data read in command 4 is ready
          memory(2) <= i2c_data_rd;              -- retrieve data from command 4
          --busy_cnt := 0;                         -- reset busy_cnt for next transaction
        end if;
      when others => null;
    end case;
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
  Led(0) <= memory(0)(0);
  Led(6 downto 3) <= "0000";
  Led(7) <= sec;

END Behavioral;
