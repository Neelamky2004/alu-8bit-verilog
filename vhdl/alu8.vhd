library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu8 is
    port (
        a        : in  std_logic_vector(7 downto 0);
        b        : in  std_logic_vector(7 downto 0);
        op       : in  std_logic_vector(2 downto 0);
        y        : out std_logic_vector(7 downto 0);
        zero     : out std_logic;
        carry    : out std_logic;
        negative : out std_logic;
        overflow : out std_logic
    );
end entity;

architecture rtl of alu8 is
begin
    process (a, b, op)
        variable tmp : unsigned(8 downto 0);
        variable res : std_logic_vector(7 downto 0);
        variable c   : std_logic;
        variable v   : std_logic;
    begin
        tmp := (others => '0');
        res := (others => '0');
        c   := '0';
        v   := '0';
        case op is
            when "000" =>
                tmp := unsigned('0' & a) + unsigned('0' & b);
                res := std_logic_vector(tmp(7 downto 0));
                c   := tmp(8);
                if a(7) = b(7) and res(7) /= a(7) then v := '1'; end if;
            when "001" =>
                tmp := unsigned('0' & a) - unsigned('0' & b);
                res := std_logic_vector(tmp(7 downto 0));
                c   := tmp(8);
                if a(7) /= b(7) and res(7) /= a(7) then v := '1'; end if;
            when "010" => res := a and b;
            when "011" => res := a or b;
            when "100" => res := a xor b;
            when "101" => res := not a;
            when "110" =>
                res := a(6 downto 0) & '0';
                c   := a(7);
            when others =>
                res := '0' & a(7 downto 1);
                c   := a(0);
        end case;

        y        <= res;
        carry    <= c;
        overflow <= v;
        negative <= res(7);
        if res = x"00" then zero <= '1'; else zero <= '0'; end if;
    end process;
end architecture;
