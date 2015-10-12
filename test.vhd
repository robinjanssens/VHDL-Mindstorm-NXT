--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:32:11 10/05/2015
-- Design Name:   
-- Module Name:   C:/Users/Robin/Documents/Mindstorm/VHDL-Mindstorm-NXT/test.vhd
-- Project Name:  VHDL-Mindstorm-NXT
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         clk : IN  std_logic;
         clr : IN  std_logic;
         en : IN  std_logic;
         analog : IN  std_logic_vector(15 downto 0);
         sda : INOUT  std_logic;
         scl : INOUT  std_logic;
         Led : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal clr : std_logic := '0';
   signal en : std_logic := '0';
   signal analog : std_logic_vector(15 downto 0) := (others => '0');

	--BiDirs
   signal sda : std_logic;
   signal scl : std_logic;

 	--Outputs
   signal Led : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          clk => clk,
          clr => clr,
          en => en,
          analog => analog,
          sda => sda,
          scl => scl,
          Led => Led
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		
		clr <= '1';
		en  <= '0';
		
      wait for 50 ns;
		
		clr <= '0';
		
		wait for 50 ns;
		
		en  <= '1';

      wait;
   end process;

END;
