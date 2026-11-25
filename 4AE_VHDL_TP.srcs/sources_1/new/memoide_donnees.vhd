
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memoire_donnees is
    Port (
        CLK : in  STD_LOGIC;
        RST : in  STD_LOGIC;
        RW  : in  STD_LOGIC;
        ADR : in  STD_LOGIC_VECTOR(7 downto 0);
        DATA_IN  : in  STD_LOGIC_VECTOR(7 downto 0);
        DATA_OUT : out STD_LOGIC_VECTOR(7 downto 0)
    );
end memoire_donnees;

architecture Behavioral of memoire_donnees is

    type memoire_type is array (0 to 255)
        of STD_LOGIC_VECTOR(7 downto 0);

    signal memoire : memoire_type := (others => (others => '0'));

begin

    process(CLK)
    begin
        if rising_edge(CLK) then

            if RST = '0' then
                -- Initialisation de toute la mémoire à zéro
                memoire <= (others => (others => '0'));

            elsif RW = '0' then
                -- Ecriture dans la mémoire
                memoire(to_integer(unsigned(ADR))) <= DATA_IN;

            elsif RW = '1' then
                -- Lecture de la mémoire
                DATA_OUT <= memoire(to_integer(unsigned(ADR)));

            end if;

        end if;
    end process;

end Behavioral;

