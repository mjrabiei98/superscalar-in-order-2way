library verilog;
use verilog.vl_types.all;
entity shl2 is
    generic(
        num_bit         : vl_notype
    );
    port(
        clk             : in     vl_logic;
        adr             : in     vl_logic_vector;
        sh_adr          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of num_bit : constant is 5;
end shl2;
