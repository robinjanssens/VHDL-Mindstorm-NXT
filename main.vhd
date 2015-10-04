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
  type    state is (state1, state2, state3, state4, state5);
  signal  present_state, next_state : state;

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
      when other =>
        present_state <= state1;
        next_state <= state1;
    end case;
  end process;

  -- =============================
  -- state Change
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

END Behavioral;
