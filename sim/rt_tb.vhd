library rt;
context rt.rt_context;

use rt.sim_pkg.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity rt_tb is generic (runner_cfg : string);
end entity;

architecture behav of rt_tb is

    constant clk_period : time := 5 ns ;
    signal clk : sl := '0';
    signal hello_world_image : pix_image_t := make_hello_world_image;
begin

    clk <= not clk after clk_period / 2 ;

    process begin
        test_runner_setup(runner, runner_cfg);
        if run("hello_world") then
            write_ppm("hello_world", hello_world_image);
        end if;
        test_runner_cleanup(runner);
    end process;

end behav;
