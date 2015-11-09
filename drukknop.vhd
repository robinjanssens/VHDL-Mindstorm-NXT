----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Jens Donckers
-- 
-- Create Date:    15:49:15 10/19/2015 
-- Design Name: 
-- Module Name:    int_drukknop - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- De interface voor de drukknoppen.

entity int_drukknop is
    Port ( d_in : in  STD_LOGIC;							-- Hier moet de drukknop aan worden gehangen
           d_out : out  STD_LOGIC;							-- Dit is de algemene uitgang van de interface
           press : out  STD_LOGIC;							-- 1 Puls hoog bij het induwen van de knop
           release : out  STD_LOGIC;						-- 1 Puls hoog bij het loslaten van de knop
           clk : in  STD_LOGIC;								-- De clock ingang
		   waitTime : in STD_LOGIC_VECTOR (7 downto 0));	-- De sensibilisering tijd tussen ingang en uitgang
end int_drukknop;

architecture Behavioral of int_drukknop is

signal signalTime : STD_LOGIC_VECTOR (21 downto 0);
signal priv_state : STD_LOGIC;
signal output : STD_LOGIC := '0';

begin

process (clk)
	begin
		if rising_edge (clk)
			then
				if not (output = d_in)	-- Bij een verschil tussen in en uit moet de teller tellen.
					then
						signalTime <= signalTime + 1;
					end if;
				if signalTime (21 downto 14) > waitTime	-- Als de tijd verstreken is, mag de uitgang zich aanpassen.
					then
						signalTime <= "0000000000000000000000";
						output <= priv_state;
						if priv_state = '0'
							then
								press <= '1';
							else
								release <= '1';
							end if;
					else
						release <= '0';
						press <= '0';
					end if;
				
					if not (d_in = priv_state)	-- Als de ingang verandert.
						then
							signalTime <= "0000000000000000000000";
							priv_state <= d_in;
						end if;
			end if;
	end process;

d_out <= not output;	-- We werken met een pullup weerstand

end Behavioral;

