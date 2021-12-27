library IEEE;
use IEEE.std_logic_1164.all;

entity DFF_en is
        port(
            resetn : in std_logic;
            clock : in std_logic;
            en : in std_logic;
            di : in std_logic;
            do : out std_logic
        );
end DFF_en;

architecture rtl of DFF_en is
    signal di_s: std_logic;
    signal do_s: std_logic;

    begin
        dff_p: process(resetn, clock)
            begin
                if resetn = '1' then
                    do_s <= '0';
                elsif (rising_edge(clock)) then
                    do_s <= di_s;
                end if;
            end process;
        di_s <= di when en='1' else do_s;
        do <= do_s;

end rtl;