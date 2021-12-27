Library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;	 


---------------------------- Entity declaration  --------------------------------
entity interleaver is
    generic( Nbit : POSITIVE := 1024);
	port(
		clock   : in std_logic;   		
       	reset   : in  std_logic;   			 	 
       	bit_in  : in std_logic;   		--  input bit	
       	bit_out : out std_logic 		--  output bit	 
    );													
	   
end interleaver;	


------------------ Architecture begins here  -----------------------------------------
architecture Behavioral of interleaver is

    ----------------------- Components declaration  ------------------------------------------	

    component DFF is
		port( 
			clk     : in std_logic;
			rst : in std_logic;
			d       : in std_logic;
			q       : out std_logic
		);
  end component;
	

    -- D-flip-flop with enable 
    component DFF_en is
    port(
        resetn : in std_logic ;
        clock : in std_logic ;
        en : in std_logic;
        di : in std_logic;
        do : out std_logic
    );
    end component DFF_en;

    -- Counter
    component counter is
    generic( N : NATURAL := 8);
    port(
        clk       : in  std_logic;
        a_rst_h   : in  std_logic;
        increment : in  std_logic_vector(N - 1 downto 0);
	    en        : in  std_logic;
        cntr_out  : out std_logic_vector(N - 1 downto 0)
    );
    end component counter;

  

    ----------------------- signals declaration  ------------------------------------------	
    signal memory_in_the_middle: std_logic_vector(Nbit-1 downto 0); -- Used to store input bits
    signal counter_i: std_logic_vector(11 downto 0); -- Signal connected to the counter output bits
    signal counter_int: integer;    --Integer signal connected to counter output to do computations
    signal a: integer;  -- Index to access to the correct element of memory in_the_middle to provide the correct output bit
    signal enables: std_logic_vector(Nbit-1 downto 0);	-- Signal to enable one at time the registers to store input bits
    signal count_en: std_logic;		-- Signal connected to counter enable
    signal bit_out_inside: std_logic;
    signal bit_in_inside: std_logic;


    begin

    dff_out: DFF
        port map(
            clk => clock,
            rst => reset,
            d => bit_out_inside,
            q => bit_out

        );

    dff_in: DFF
        port map(
            clk => clock,
            rst => reset,
            d => bit_in,
            q => bit_in_inside

    );

    -- Create a certain number of DFF_en, one for each input bit
    GEN: for i in 0 to Nbit-1 generate
   
    dff_i: DFF_en
        port map (
            clock => clock,
            resetn => reset,
            en => enables(i),
            di => bit_in_inside,
            do => memory_in_the_middle(i)

        );
    
    end generate GEN;

    -- Counter to discriminate the input phase (first Nbit clock cycle) or the output phase (last Nbit clock cycle)
    -- The counter is 12-bit, assuming that I can implement an interleaver working with a maximum of 1024 bits
    -- In case of 1024 bits interleaver I need to count up to 2048 so I need 12 bits
    count: counter 
	generic map (N => 12)
    port map(
        clk => clock,
        a_rst_h => reset,
        increment  => "000000000001",
		en => count_en,
        cntr_out  => counter_i
        );

	    proc: process(clock, reset)
            
        begin
           
            -- Initialize all signals
         
            if reset = '1' then	 	 
                    
                    a<=0;	
                    bit_out_inside<='Z'; -- Output not relevant 
                    counter_int <= 0; --The counter is not yet active
                    count_en <= '1'; -- Activate the counter, which will start counting anyway at the falling edge of the reset
                    for i in 0 to Nbit-1 loop   -- Aet all the enables of the d-flip-flops to 0, i.e. 
                        enables(i) <='0';        -- with the output going back to the register input,  so in the holding phase.
                    end loop;
                    
            elsif rising_edge(clock) then  
            -- I connect the output of the counter to a signal of integer type in order to make the computations

                    counter_int <= ieee.NUMERIC_STD.TO_INTEGER(unsigned(counter_i));
                    -- The first Nbit clock cycles are used to store input bits, at each cycle, I set the corresponding enable signal 
                    -- so I can acquire the input bit in the register, I set the previous enable signal to 0 so
                    -- I do not lose the bit acquired previously
                    if counter_int < Nbit then
                        if(counter_int /= 0) then
                            enables(counter_int-1) <= '0';
                        end if;
                        
                        enables(counter_int)<= '1';
                       
                    elsif counter_int <= Nbit*2 then
                    -- The last Nbit clock cycles are used to emit the output bits one at a time.
                    -- The registers are connected to an intermediate signal, memory_in_the_middle which at the end of the first 1024 bits (input phase)
                    -- will store 1024 input bits
                    -- I use the "a" signal to shuffling the bits, then calculate the index of the bit to emit in output
                        
                        a <= ((45+((counter_int mod Nbit)*3)) mod Nbit);


                         if counter_int = Nbit then -- I set to 0 the last enable signal
                            enables(counter_int -1) <= '0';
                            bit_out_inside <= 'Z';
                        else
                         --I output the bits one by one
                        bit_out_inside <= memory_in_the_middle(a); 
                        end if;
                       
                        if counter_int = Nbit*2 then
                            count_en <= '0'; -- Reset the counter
                        end if;
                    
                    -- If the output phase in conclused I will set all the signals to start a new acquisition

                    elsif counter_int  > Nbit*2 then
                        a<=0;	
                        bit_out_inside<='Z';
                        count_en <= '1';
                        
                    end if;	
            end if;	
			
    end process proc;	
  
end Behavioral;	