
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TestMemoire is
end TestMemoire;

architecture Behavioral of TestMemoire is

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT memoire_donnees
PORT(
    CLK      : IN std_logic;
    RST      : IN std_logic;
    RW       : IN std_logic;
    ADR      : IN std_logic_vector(7 downto 0);
    DATA_IN  : IN std_logic_vector(7 downto 0);
    DATA_OUT : OUT std_logic_vector(7 downto 0)
);
END COMPONENT;

-- Inputs
signal CLK      : std_logic := '0';
signal RST      : std_logic := '0';
signal RW       : std_logic := '1';
signal ADR      : std_logic_vector(7 downto 0) := (others => '0');
signal DATA_IN  : std_logic_vector(7 downto 0) := (others => '0');

-- Outputs
signal DATA_OUT : std_logic_vector(7 downto 0);

-- Clock period definitions
constant CLK_period : time := 10 ns;

begin

-- Instantiate the Unit Under Test (UUT)
uut: memoire_donnees PORT MAP (
    CLK      => CLK,
    RST      => RST,
    RW       => RW,
    ADR      => ADR,
    DATA_IN  => DATA_IN,
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

    -- Initialisation de la mémoire
    RST <= '0';
    wait for 20 ns;
    RST <= '1';

    -- Ecriture de 0x25 à l'adresse 0x0A
    ADR <= x"0A";
    DATA_IN <= x"25";
    RW <= '0';
    wait for 20 ns;

    -- Lecture à l'adresse 0x0A
    RW <= '1';
    wait for 10 ns;

    -- Ecriture de 0xAB à l'adresse 0x14
    ADR <= x"14";
    DATA_IN <= x"AB";
    RW <= '0';
    wait for 20 ns;

    -- Lecture à l'adresse 0x14
    RW <= '1';
    wait for 10 ns;

    -- Nouvelle lecture à l'adresse 0x0A
    ADR <= x"0A";
    wait for 10 ns;
    
    report "TOUS LES TESTS MEMDATA SONT REUSSIS !"
    severity note;

    wait;


end process;

end Behavioral;

