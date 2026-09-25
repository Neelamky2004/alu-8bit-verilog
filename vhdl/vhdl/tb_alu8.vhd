library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_alu8 is
end entity;

architecture sim of tb_alu8 is
    signal a, b, y : std_logic_vector(7 downto 0);
    signal op      : std_logic_vector(2 downto 0);
    signal zero, carry, negative, overflow : std_logic;
begin
    dut : entity work.alu8
        port map (a, b, op, y, zero, carry, negative, overflow);

    process
        variable errors : integer := 0;
        variable tests  : integer := 0;
        variable ai, bi, t : integer;
        variable ey : unsigned(7 downto 0);
        variable ec, ev : std_logic;
    begin
        for o in 0 to 7 loop
            for ia in 0 to 255 loop
                for ib in 0 to 255 loop
                    a  <= std_logic_vector(to_unsigned(ia, 8));
                    b  <= std_logic_vector(to_unsigned(ib, 8));
                    op <= std_logic_vector(to_unsigned(o, 3));
                    wait for 1 ns;

                    ec := '0';
                    ev := '0';
                    case o is
                        when 0 =>
                            t  := ia + ib;
                            ey := to_unsigned(t mod 256, 8);
                            if t > 255 then ec := '1'; end if;
                        when 1 =>
                            t  := ia - ib;
                            ey := to_unsigned((t + 256) mod 256, 8);
                            if t < 0 then ec := '1'; end if;
                        when 2 => ey := to_unsigned(ia, 8) and to_unsigned(ib, 8);
                        when 3 => ey := to_unsigned(ia, 8) or to_unsigned(ib, 8);
                        when 4 => ey := to_unsigned(ia, 8) xor to_unsigned(ib, 8);
                        when 5 => ey := not to_unsigned(ia, 8);
                        when 6 =>
                            ey := to_unsigned((ia * 2) mod 256, 8);
                            if ia >= 128 then ec := '1'; end if;
                        when others =>
                            ey := to_unsigned(ia / 2, 8);
                            if ia mod 2 = 1 then ec := '1'; end if;
                    end case;

                    if o = 0 then
                        ai := to_integer(signed(to_unsigned(ia, 8)));
                        bi := to_integer(signed(to_unsigned(ib, 8)));
                        if ai + bi > 127 or ai + bi < -128 then ev := '1'; end if;
                    elsif o = 1 then
                        ai := to_integer(signed(to_unsigned(ia, 8)));
                        bi := to_integer(signed(to_unsigned(ib, 8)));
                        if ai - bi > 127 or ai - bi < -128 then ev := '1'; end if;
                    end if;

                    tests := tests + 1;
                    if y /= std_logic_vector(ey) or carry /= ec or overflow /= ev
                       or negative /= ey(7) or (zero = '1') /= (ey = 0) then
                        errors := errors + 1;
                        if errors <= 10 then
                            report "FAIL op=" & integer'image(o) & " a=" & integer'image(ia)
                                   & " b=" & integer'image(ib) severity warning;
                        end if;
                    end if;
                end loop;
            end loop;
        end loop;

        report "Tests run : " & integer'image(tests);
        report "Errors    : " & integer'image(errors);
        if errors = 0 then
            report "RESULT    : PASS";
        else
            report "RESULT    : FAIL";
        end if;
        wait;
    end process;
end architecture;
