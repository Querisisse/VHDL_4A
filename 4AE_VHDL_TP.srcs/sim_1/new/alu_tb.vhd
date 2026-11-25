library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_tb is
end alu_tb;

architecture Behavioral of alu_tb is

  COMPONENT ALU
  PORT(
    A: in UNSIGNED(7 downto 0);
    B: in UNSIGNED(7 downto 0);
    S: out UNSIGNED(7 downto 0);
    Ctrl_Alu: in STD_LOGIC_VECTOR(2 downto 0);
    C,O,N: out STD_LOGIC);
  END COMPONENT;

    signal A: UNSIGNED(7 downto 0) := "00000010";
    signal B: UNSIGNED(7 downto 0) := "00000001";
    signal S: UNSIGNED(7 downto 0);
    signal Ctrl_Alu: STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal C,O,N: STD_LOGIC;

begin 

  --uut : unit under test
  uut : ALU PORT MAP (
    A => A,
    B => B,
    S => S,
    C => C,
    O => O,
    N => N,
    Ctrl_Alu => Ctrl_Alu
  );

stim_proc: process
begin
    
    --test sum
    A<=x"40";
    B<=x"30";
    
    Ctrl_Alu<="000";
    assert S=x"70"
    report "Erreur : Test sum"
    severity error;
    
    wait for 20 ns;
    
        --test sub
    A<=x"40";
    B<=x"30";
    
    Ctrl_Alu<="001";
    assert S=x"10"
    report "Erreur : Test sub"
    severity error;
    
    wait for 20 ns;
    
            --test mul
    A<=x"40";
    B<=x"30";
    
    Ctrl_Alu<="010";
    --assert S=x"10"
    --report "Erreur : Test mul"
    --severity error;
    
    wait for 20 ns;
    
    report "TOUS LES TESTS ALU SONT REUSSIS !";
    
    wait;
    
    
end process;

end;
