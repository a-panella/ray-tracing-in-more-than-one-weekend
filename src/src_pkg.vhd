library rt;
context rt.rt_base_context;

package src_pkg is

    subtype sl is std_logic;
    subtype slv is std_logic_vector;
    subtype slv0 is std_logic_vector(0 downto 0);

    subtype rgb_int_t is integer range 0 to 255;

    constant pix_width : natural := 600;
    constant pix_height : natural := 400;

    type rgb_triplet_int_t is record
        r : rgb_int_t;
        g : rgb_int_t;
        b : rgb_int_t;
    end record;

    type pix_row_t is array (0 to pix_width-1) of rgb_triplet_int_t;
    type pix_image_t is array (0 to pix_height-1) of pix_row_t;

end package src_pkg;

