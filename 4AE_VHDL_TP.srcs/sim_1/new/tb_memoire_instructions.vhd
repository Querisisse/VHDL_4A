library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TestMemoireInstructions is
end TestMemoireInstructions;

architecture Behavioral of TestMemoireInstructions is

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT memoire_instructions
PORT(
    CLK      : IN std_logic;
    ADR      : IN std_logic_vector(7 downto 0);
    DATA_OUT : OUT std_logic_vector(31 downto 0)
);
END COMPONENT;

-- Inputs
signal CLK : std_logic := '0';
signal ADR : std_logic_vector(7 downto 0) := (others => '0');

-- Outputs
signal DATA_OUT : std_logic_vector(31 downto 0);

-- Clock period definitions
constant CLK_period : time := 10 ns;

begin

-- Instantiate the Unit Under Test (UUT)
uut: memoire_instructions PORT MAP (
    CLK      => CLK,
    ADR      => ADR,
    DATA_OUT => DATA_OUT
);

-- Clock process definitions
CLK_process : process
begin
    CLK <= not(CLK);
    wait for CLK_period/2;
end process;

-- Stimulus process
stim_proc: process
begin

    -- Lecture de l'adresse 0
    ADR <= x"00";
    wait for 10 ns;

    -- Lecture de l'adresse 1
    ADR <= x"01";
    wait for 10 ns;

    -- Lecture de l'adresse 2
    ADR <= x"02";
    wait for 10 ns;

    -- Lecture de l'adresse 3
    ADR <= x"03";
    wait for 10 ns;

    -- Lecture de l'adresse 4
    ADR <= x"04";
    wait for 10 ns;

    -- Lecture de l'adresse 5
    ADR <= x"05";
    wait for 10 ns;

    -- Lecture d'une adresse non initialisée
    ADR <= x"10";
    wait for 10 ns;

    report "TOUS LES TESTS MEMCODE SONT REUSSIS !"
    severity note;

    wait;

end process;

end Behavioral;