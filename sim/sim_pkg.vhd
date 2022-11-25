library rt;
context rt.rt_context;

use std.textio.all;

package sim_pkg is

    procedure wait_cycles(signal clk_i : in sl; constant num_cyc : in natural);

    -- procedure write_ppm(signal image : in pix_image_t);
    procedure write_ppm(constant image_name : in string; signal image : in pix_image_t);

    function make_hello_world_image return pix_image_t;

end package;

package body sim_pkg is

    procedure wait_cycles(signal clk_i : in sl; constant num_cyc : in natural) is begin
        for cyc_num in 0 to num_cyc-1 loop
            wait until rising_edge(clk_i);
        end loop;
    end procedure;

    procedure write_ppm(constant image_name : in string; signal image : in pix_image_t) is 
        file fimage : text open write_mode is image_name & ".ppm";
        variable L : line;
        variable row : pix_row_t;
    begin
        swrite(L, "P3");
        writeline(fimage, L);
        write(L, integer'image(pix_width) & " " & integer'image(pix_height));
        writeline(fimage, L);
        swrite(L, "255");
        writeline(fimage, L);
        for r in 0 to image'length-1 loop
            row := image(r);
            for p in 0 to row'length-1 loop
                if p = row'length-1 then
                    write(L, integer'image(row(p).r) & " " & integer'image(row(p).g) & " " & integer'image(row(p).b));
                else
                    write(L, integer'image(row(p).r) & " " & integer'image(row(p).g) & " " & integer'image(row(p).b) & " ");
                end if;
            end loop;
            writeline(fimage, L);
        end loop;
    end procedure;

    function make_hello_world_image return pix_image_t is 
        variable image : pix_image_t;
        variable row : pix_row_t;
        variable r_real,g_real, b_real : real := 0.25;
    begin
        for r in 0 to image'length-1 loop
            for p in 0 to row'length-1 loop
                r_real := real(p) / real(pix_width);
                g_real := real(r) / real(pix_height);
                row(p).r := integer(floor(255.999 * r_real));
                row(p).g := integer(floor(255.999 * g_real));
                row(p).b := integer(floor(255.999 * b_real));
            end loop;
            image(r) := row;
        end loop;
        return image;
    end function;

end package body;