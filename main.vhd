----------------------------------------------------------------------------------
-- Written by: Robin Janssens, Jens Donckers & Rudi Conings
-- Commissioned by: University of Antwerp
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
    Port ( 
	   an     : out    STD_LOGIC_VECTOR (3 downto 0);
	   Led    : out    STD_LOGIC_VECTOR (7 downto 0));
end main;

ARCHITECTURE Behavioral of main is

BEGIN

Led <= "11111111";
an  <= "0000";

END Behavioral;
