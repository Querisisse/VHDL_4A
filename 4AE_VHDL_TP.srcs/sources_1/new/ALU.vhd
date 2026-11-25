
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
  port(
            A: in UNSIGNED(7 downto 0);
            B: in UNSIGNED(7 downto 0);
            S: out UNSIGNED(7 downto 0);
            Ctrl_Alu: in STD_LOGIC_VECTOR(2 downto 0);
            C,O,N: out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
      signal S_res:  UNSIGNED(15 downto 0);
begin

--  s <= a when i=0 else b;
  C <= '1' when (S_res(8)= '1' or (A(7)=B(7) and A(7)='0' and S_res(7)='1')) else '0';
  O <= '1' when (S_res(8)= '1') else '0';
  N <= '1' when (S_res(7)= '1') else '0';
  process(A,B,Ctrl_Alu)
  begin
      case(Ctrl_Alu) is
      when "000" =>
        S_res <= RESIZE(A, 16) + RESIZE(B, 16) ;

      when "001" =>
        S_res <= RESIZE(A, 16) - RESIZE(B, 16) ;
        
      when "010" =>
        
        S_res <= A*B ;

              when "011" =>
            S_res <= UNSIGNED(x"00"&STD_LOGIC_VECTOR(A) or x"00"&STD_LOGIC_VECTOR(B));
      when "100" =>
            S_res <= UNSIGNED(x"00"&STD_LOGIC_VECTOR(A) and x"00"&STD_LOGIC_VECTOR(B));
      when "101" =>
            S_res <= UNSIGNED(x"00"&STD_LOGIC_VECTOR(A) xor x"00"&STD_LOGIC_VECTOR(B));
      when "110" =>
            S_res <= UNSIGNED(not x"00"&STD_LOGIC_VECTOR(A));
      when others =>
            null;
    end case;

      end process;
      S <= S_res(7 downto 0);
end Behavioral;
