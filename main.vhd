----------------------------------------------------------------------------------
-- Written by: Robin Janssens & Jens Donckers
-- Commissioned by: University of Antwerp
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

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
  type		mode is (mode1, mode2, mode3, mode4, mode5);
  signal	present_mode, next_mode : mode;

  -- =============================
  -- Components
  -- =============================


BEGIN

  -- =============================
  -- Port Mappings
  -- =============================


  -- =============================
  -- Main Code
  -- =============================
  main: process (present_mode) --, inputs)
  begin
    case present_mode is
			when mode1 =>
        -- code
      when mode2 =>
        -- code
      when mode3 =>
        -- code
      when mode4 =>
        -- code
      when mode5 =>
        -- code
    end case;
  end process;


END Behavioral;
