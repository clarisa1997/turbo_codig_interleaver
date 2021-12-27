-- Librerie utilizzate

library IEEE;
use IEEE.std_logic_1164.all;	   

entity interleaver_tb_2 is	
end interleaver_tb_2;	   

-- Dichiarazione dell'entità

architecture interleaver_test_2 of interleaver_tb_2 is
	component interleaver
	generic (Nbit : POSITIVE := 1024);
		port (
			clock		: in std_logic;							-- segnale di clock
			reset	: in std_logic;							-- segnale di reset
			bit_in		: in std_logic;	-- ingresso
			bit_out 	: out std_logic	-- uscita
			);
	end component;	

-----------------------------------------------------

--CONSTANT
	CONSTANT clock_period : TIME := 8 ns;
	CONSTANT len : INTEGER := 2051;

	--INPUT SIGNALS
	SIGNAL clock_tb : std_logic := '0';
	SIGNAL reset_tb : std_logic := '1';
	SIGNAL bit_in_tb : std_logic := '0';


	--OUTPUT SIGNALS
	SIGNAL bit_out_tb : std_logic := '0';

	
	SIGNAL testing: Boolean :=True;

	signal count: INTEGER:= 0;

	BEGIN
		I: interleaver 
		generic map(Nbit => 1024)
		PORT MAP(clock => clock_tb, 
			reset => reset_tb, 
			bit_in => bit_in_tb, 
			bit_out =>bit_out_tb);

--Generates clk
	clock_tb <=NOT clock_tb AFTER clock_period/2 WHEN testing ELSE '0';
    reset_tb <= '0' after 10*clock_Period;

    --Runs simulation for len cycles
    proc_test: process(clock_tb, reset_tb)
        	
    begin
		
        if(reset_tb = '1') then
				bit_in_tb <= '0';
                count <= 0;
        elsif rising_edge(clock_tb) then 
            
            --bit_in_tb <= '0';
            bit_in_tb <= '1';
			if count > 1025 then
                bit_in_tb <= 'Z';
            end if;
            if count = len then testing <= false;	  -- fine test	
            end if;
			if(count >= len) then NULL;
            end if;	
            count <= count + 1;	
		end if;
		

	
	end process proc_test;
	
end interleaver_test_2;