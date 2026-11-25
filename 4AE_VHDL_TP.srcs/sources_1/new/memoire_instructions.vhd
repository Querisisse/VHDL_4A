library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memoire_instructions is
    Port (
        CLK      : in  STD_LOGIC;
        ADR      : in  STD_LOGIC_VECTOR(7 downto 0);
        DATA_OUT : out STD_LOGIC_VECTOR(31 downto 0)
    );
end memoire_instructions;

architecture Behavioral of memoire_instructions is

    type memoire_type is array (0 to 255)
        of STD_LOGIC_VECTOR(31 downto 0);

    -- Initialisation du programme dans la mémoire
    signal memoire : memoire_type := (
        x"06010300", --AFC R1 3
        x"00000000",
        x"06020800", --AFC R2 08
        x"00000000",
        x"00000000",
        x"00000000",
--        5 => x"05030100",-- COP R3 R1
--        6=> X"01040102", --ADD R4 R1 R2
        others => x"00000000"
    );

begin

    -- Lecture synchrone de la mémoire
    process(CLK)
    begin
        if rising_edge(CLK) then
            DATA_OUT <= memoire(to_integer(unsigned(ADR)));
        end if;
    end process;

end Behavioral;
