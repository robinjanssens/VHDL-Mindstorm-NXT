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

architecture Behavioral of main is

begin


end Behavioral;
