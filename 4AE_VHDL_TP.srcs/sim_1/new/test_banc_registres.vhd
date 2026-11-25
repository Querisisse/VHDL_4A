----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2026 05:24:48 PM
-- Design Name: 
-- Module Name: test_banc_registres - Behavioral
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



entity test_banc_registres is
end test_banc_registres;

architecture Behavioral of test_banc_registres is

-- Component Declaration for the Unit Under Test (UUT)

COMPONENT banc_registres
PORT(
    CLK      : IN std_logic;
    RST      : IN std_logic;
    adress_A : IN std_logic_vector(3 downto 0);
    adress_B : IN std_logic_vector(3 downto 0);
    adress_W : IN std_logic_vector(3 downto 0);
    W        : IN std_logic;
    DATA     : IN std_logic_vector(7 downto 0);
    QA       : OUT std_logic_vector(7 downto 0);
    QB       : OUT std_logic_vector(7 downto 0)
);
END COMPONENT;

-- Inputs

signal CLK      : std_logic := '0';
signal RST      : std_logic := '1';

signal adress_A : std_logic_vector(3 downto 0) := (others => '0');
signal adress_B : std_logic_vector(3 downto 0) := (others => '0');
signal adress_W : std_logic_vector(3 downto 0) := (others => '0');

signal W        : std_logic := '0';
signal DATA     : std_logic_vector(7 downto 0) := (others => '0');

-- Outputs

signal QA : std_logic_vector(7 downto 0);
signal QB : std_logic_vector(7 downto 0);

-- Clock period definitions

constant Clock_period : time := 10 ns;

begin

-- Instantiate the Unit Under Test (UUT)

uut: banc_registres PORT MAP (
    CLK      => CLK,
    RST      => RST,
    adress_A => adress_A,
    adress_B => adress_B,
    adress_W => adress_W,
    W        => W,
    DATA     => DATA,
    QA       => QA,
    QB       => QB
);

-- Clock process definitions

Clock_process : process
begin
    CLK <= not(CLK);
    wait for Clock_period/2;
end process;

-- Stimulus process

stim_proc: process
begin

    ------------------------------------------------
    -- TEST 1 : RESET
    ------------------------------------------------

    RST <= '0';

    wait until rising_edge(CLK);
    wait for 1 ns;

    assert QA = x"00" and QB = x"00"
    report "Erreur TEST 1 : Reset"
    severity error;

    RST <= '1';

    ------------------------------------------------
    -- TEST 2 : ECRITURE DANS R1
    ------------------------------------------------

    wait until falling_edge(CLK);

    W <= '1';
    adress_W <= "0001";
    DATA <= x"25";

    wait until rising_edge(CLK);
    wait for 1 ns;

    W <= '0';

    ------------------------------------------------
    -- TEST 3 : ECRITURE DANS R2
    ------------------------------------------------

    wait until falling_edge(CLK);

    W <= '1';
    adress_W <= "0010";
    DATA <= x"40";

    wait until rising_edge(CLK);
    wait for 1 ns;

    W <= '0';

    ------------------------------------------------
    -- TEST 4 : LECTURE SIMULTANEE DE R1 ET R2
    ------------------------------------------------

    adress_A <= "0001";
    adress_B <= "0010";

    wait for 1 ns;

    assert QA = x"25" and QB = x"40"
    report "Erreur TEST 4 : Lecture simultanee"
    severity error;

    ------------------------------------------------
    -- TEST 5 : BYPASS SUR LE PORT A
    ------------------------------------------------

    wait until falling_edge(CLK);

    W <= '1';
    adress_W <= "0001";
    adress_A <= "0001";
    DATA <= x"55";

    wait for 1 ns;

    assert QA = x"55"
    report "Erreur TEST 5 : Bypass port A"
    severity error;

    wait until rising_edge(CLK);
    wait for 1 ns;

    W <= '0';

    ------------------------------------------------
    -- TEST 6 : BYPASS SUR LE PORT B
    ------------------------------------------------

    wait until falling_edge(CLK);

    W <= '1';
    adress_W <= "0010";
    adress_B <= "0010";
    DATA <= x"66";

    wait for 1 ns;

    assert QB = x"66"
    report "Erreur TEST 6 : Bypass port B"
    severity error;

    wait until rising_edge(CLK);
    wait for 1 ns;

    W <= '0';

    ------------------------------------------------
    -- TEST 7 : BYPASS SUR LES DEUX PORTS
    ------------------------------------------------

    wait until falling_edge(CLK);

    W <= '1';
    adress_W <= "0011";
    adress_A <= "0011";
    adress_B <= "0011";
    DATA <= x"AA";

    wait for 1 ns;

    assert QA = x"AA" and QB = x"AA"
    report "Erreur TEST 7 : Double bypass"
    severity error;

    wait until rising_edge(CLK);
    wait for 1 ns;

    W <= '0';

    ------------------------------------------------
    -- TEST 8 : CONSERVATION DES DONNEES
    ------------------------------------------------

    adress_A <= "0001";
    adress_B <= "0010";

    wait for 1 ns;

    assert QA = x"55" and QB = x"66"
    report "Erreur TEST 8 : Conservation des donnees"
    severity error;

    ------------------------------------------------
    -- TEST 9 : RESET COMPLET
    ------------------------------------------------

    wait until falling_edge(CLK);

    RST <= '0';

    wait until rising_edge(CLK);
    wait for 1 ns;

    RST <= '1';

    wait for 1 ns;

    assert QA = x"00" and QB = x"00"
    report "Erreur TEST 9 : Reset complet"
    severity error;

    ------------------------------------------------
    -- FIN DES TESTS
    ------------------------------------------------

    report "TOUS LES TESTS SONT REUSSIS !"
    severity note;

    wait;

end process;

end Behavioral;
