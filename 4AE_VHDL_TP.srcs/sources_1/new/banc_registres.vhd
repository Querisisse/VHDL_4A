----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2026 04:32:34 PM
-- Design Name: 
-- Module Name: banc_registres - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity banc_registres is
    Port (
        CLK  : in  STD_LOGIC;
        RST  : in  STD_LOGIC;

        -- Adresses de lecture
        adress_A    : in  STD_LOGIC_VECTOR(3 downto 0);
        adress_B    : in  STD_LOGIC_VECTOR(3 downto 0);

        -- Adresse d'ecriture
        adress_W : in STD_LOGIC_VECTOR(3 downto 0);

        -- Commande d'ecriture
        W    : in  STD_LOGIC;

        -- Donnees
        DATA : in  STD_LOGIC_VECTOR(7 downto 0);

        -- Sorties de lecture
        QA   : out STD_LOGIC_VECTOR(7 downto 0);
        QB   : out STD_LOGIC_VECTOR(7 downto 0)
    );
end banc_registres;

architecture Behavioral of banc_registres is

    -- 16 registres de 8 bits
    type reg_array is array (0 to 15)
        of STD_LOGIC_VECTOR(7 downto 0);

    signal REG : reg_array := (others => (others => '0'));

begin

    -- Processus d'ecriture et de reset
    process(CLK)
    begin
        if rising_edge(CLK) then

            -- Reset synchrone actif a 0
            if RST = '0' then
                REG <= (others => (others => '0'));

            -- Ecriture
            elsif W = '1' then
                REG(to_integer(unsigned(adress_W))) <= DATA;
            end if;

        end if;
    end process;
            QA <= REG(to_integer(unsigned(adress_A)));
            QB <= REG(to_integer(unsigned(adress_B)));


end Behavioral;

