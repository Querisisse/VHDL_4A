
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity uP is
   Port (
    signal uP_CLK : in STD_LOGIC;
    signal uP_RST : in STD_LOGIC;
    signal uP_QA : out STD_LOGIC_vector(7 downto 0);
    signal uP_QB : out STD_LOGIC_vector(7 downto 0));
    
end uP;


architecture Behavioral of uP is

component banc_registres is
    Port (
        CLK  : in  STD_LOGIC;
        RST  : in  STD_LOGIC;
        adress_A    : in  STD_LOGIC_VECTOR(3 downto 0);
        adress_B    : in  STD_LOGIC_VECTOR(3 downto 0);
        adress_W : in STD_LOGIC_VECTOR(3 downto 0);
        W    : in  STD_LOGIC;
        DATA : in  STD_LOGIC_VECTOR(7 downto 0);
        QA   : out STD_LOGIC_VECTOR(7 downto 0);
        QB   : out STD_LOGIC_VECTOR(7 downto 0)
    );
end component ;

component ALU is
  port(
            A: in UNSIGNED(7 downto 0);
            B: in UNSIGNED(7 downto 0);
            S: out UNSIGNED(7 downto 0);
            Ctrl_Alu: in STD_LOGIC_VECTOR(2 downto 0);
            C,O,N: out STD_LOGIC);
end component ;

component memoire_instructions is
    Port (
        CLK      : in  STD_LOGIC;
        ADR      : in  STD_LOGIC_VECTOR(7 downto 0);
        DATA_OUT : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component ;

component memoire_donnees is
    Port (
        CLK : in  STD_LOGIC;
        RST : in  STD_LOGIC;
        RW  : in  STD_LOGIC;
        ADR : in  STD_LOGIC_VECTOR(7 downto 0);
        DATA_IN  : in  STD_LOGIC_VECTOR(7 downto 0);
        DATA_OUT : out STD_LOGIC_VECTOR(7 downto 0)
    );
end component ;
    

signal A_LIDI : std_logic_vector(7 downto 0);
signal A_DIEX : std_logic_vector(7 downto 0); 
signal A_EXMEM : std_logic_vector(7 downto 0); 
signal A_MEMRE : std_logic_vector(7 downto 0);

signal B_LIDI : std_logic_vector(7 downto 0);
signal B_DIEX : std_logic_vector(7 downto 0); 
signal B_EXMEM : std_logic_vector(7 downto 0); 
signal B_MEMRE : std_logic_vector(7 downto 0);

signal OP_LIDI : std_logic_vector(7 downto 0);
signal OP_DIEX : std_logic_vector(7 downto 0); 
signal OP_EXMEM : std_logic_vector(7 downto 0); 
signal OP_MEMRE : std_logic_vector(7 downto 0);

signal C_LIDI : std_logic_vector(7 downto 0);
signal C_DIEX : std_logic_vector(7 downto 0); 
signal C_EXMEM : std_logic_vector(7 downto 0); 
signal C_MEMRE : std_logic_vector(7 downto 0);

signal IP : std_logic_vector(7 downto 0);
signal instruction : std_logic_vector(31 downto 0);
signal sig_W : std_logic ;
signal Sig_QA, sig_QB : std_logic_vector (7 downto 0);

signal flag_C, flag_O, flag_N : std_logic;
signal sig_S : unsigned (7 downto 0);
signal  sig_Ctrl_Alu : std_logic_vector (2 downto 0);
signal sig_RW : STD_LOGIC;
signal sig_data_out : STD_LOGIC_VECTOR(7 downto 0);

begin

mem_instr : memoire_instructions 
port map (
        CLK=> uP_CLk,
        ADR  => IP,
        DATA_OUT => instruction);

reg : banc_registres
    Port map  (
        CLK  => uP_CLk,
        RST  => uP_RST,
        adress_A => B_LIDI (3 downto 0),
        adress_B => C_LIDI(3 downto 0),
        adress_W => A_MEMRE(3 downto 0),
        W   => sig_W,
        DATA => B_MEMRE,
        QA  => sig_QA,
        QB => sig_QB ) ;
        
unital : ALU 
  port map(
            A => unsigned(B_DIEX),
            B => unsigned(C_DIEX),
            S =>sig_S,
            Ctrl_Alu => sig_Ctrl_Alu,
            C=>flag_C,
            O => flag_O,
            N=> flag_N
            );

mem_data : memoire_donnees
    Port map(
        CLK => up_CLK,
        RST => up_RST,
        RW  => sig_RW,
        ADR => B_EXMEM,
        DATA_IN => B_EXMEM,
        DATA_OUT => sig_data_out
    );

    
    
    uP_QA <= sig_QA;
    uP_QB <= sig_QB ;
    
    --ATTENTIONNNN FAILLE SECU MATERIELLE SI OPCODE INCONNU ON ECRIT DANS UN REGISTE 
    sig_W <= '0' when (OP_MEMRE = x"08") else '1';
    
    
    
   
    
   
    
    
    
    process(uP_CLK)
    begin 
    if rising_edge(uP_CLK) then 
        
        if uP_RST ='0' then 
            IP <= X"00" ;
            --tout remettre à 0
         
        else  
         
            IP <= IP+ 1;
            A_LIDI <= instruction (23 downto 16);
            OP_LIDI<= instruction(31 downto 24);
            B_LIDI <=instruction ( 15 downto 8);
            C_LIDI <=instruction (7 downto 0);
            
            

            A_DIEX <= A_LIDI;
            A_EXMEM <= A_DIEX;
            A_MEMRE <= A_EXMEM; 
            
            --MUX étage 2 (COP)
            case(OP_LIDI) is
            when x"05" =>
                B_DIEX <= sig_QA;
            when others =>
                B_DIEX <= B_LIDI;
            end case; 
            
             --Mux étage 3 (question 3), en gros si on se sert de l'alu on recupere S
             -- On met tout les unsigned en std_logic_vector?
            B_EXMEM <= std_logic_vector(sig_S) when (OP_DIEX = x"01" or OP_DIEX = x"02" or OP_DIEX = x"03"
            or OP_DIEX = x"14" or OP_DIEX = x"15" or OP_DIEX = x"16" or OP_DIEX = x"17")
            else B_DIEX;
            
            --Mux étage 4 (LOAD)
            case (OP_EXMEM) is
            when x"07" =>
                B_MEMRE <= sig_data_out;
            when others =>
                B_MEMRE <= B_EXMEM;
            end case;

            
--            C_DIEX <= C_LIDI;
--            C_EXMEM <= C_DIEX;
--            C_MEMRE <= C_EXMEM; 
            
            OP_DIEX <= OP_LIDI;
            OP_EXMEM <= OP_DIEX;
            OP_MEMRE <= OP_EXMEM; 
             --Le LC de l'étage 3 (question 3)
            case(OP_DIEX) is
            when x"01" =>
                sig_Ctrl_ALU <= "000" ;
            when x"02" =>
                sig_Ctrl_ALU <= "010" ;
            when x"03" =>
                sig_Ctrl_ALU <= "001" ;
            when x"14" =>
                sig_Ctrl_ALU <= "100" ;
            when x"15" =>
                sig_Ctrl_ALU <= "011" ;
            when x"16" =>
                sig_Ctrl_ALU <= "101" ;
            when x"17" =>
                sig_Ctrl_ALU <= "110" ;
            when others =>
                null;
             end case;
              
            --LC étage 4 (LOAD)
            case(OP_EXMEM) is
            when x"07" =>
                sig_RW <= '0';
            when others =>
                null;
            end case;
            
            
   
        end if; 
    end if ;
        
    end process; 


end Behavioral;
