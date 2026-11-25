----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2026 06:34:44 PM
-- Design Name: 
-- Module Name: test_uP - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_uP is
--  Port ( );
end test_uP;

architecture Behavioral of test_uP is
    
COMPONENT uP is
   Port (
    signal uP_CLK : in STD_LOGIC;
    signal uP_RST : in STD_LOGIC;
    signal uP_QA : out STD_LOGIC_vector(7 downto 0);
    signal uP_QB : out STD_LOGIC_vector(7 downto 0));
end COMPONENT;

signal uP_CLK : STD_LOGIC := '0';
signal uP_RST : STD_LOGIC := '1';
signal uP_QA : STD_LOGIC_vector(7 downto 0);
signal uP_QB : STD_LOGIC_vector(7 downto 0);

constant Clock_period : time := 10 ns;
 
begin

    uut: uP PORT MAP(
        uP_CLK => uP_CLK,
        uP_RST => uP_RST,
        uP_QA => uP_QA,
        uP_QB => uP_QB);
    
    Clock_process : process
    begin
        uP_CLK <= not(uP_CLK);
        wait for Clock_period/2;
    end process;

end Behavioral;
