library IEEE;
use IEEE.std_logic_1164.all;

-- 1024-bit interleaver
entity interleaver_1024 is
	port (
		clock		:	in	std_logic;	
		reset	:	in	std_logic;	
		bit_in		:	in	std_logic; 
		bit_out		:	out	std_logic  
	);
end interleaver_1024;	

architecture struct of interleaver_1024 is

component interleaver
	generic (Nbit : POSITIVE := 1024);
	port (
		clock		:	in	std_logic;
		reset	:	in	std_logic;
		bit_in		:	in	std_logic;
		bit_out		:	out	std_logic
	);
end component;

begin
	
	
	inter: interleaver
	generic map(Nbit => 1024)
	port map(	clock => clock, 
				reset => reset, 
				bit_in => bit_in, 
				bit_out => bit_out);

end struct;