library verilog;
use verilog.vl_types.all;
entity \register\ is
    generic(
        num_bit         : vl_notype
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        en              : in     vl_logic;
        din             : in     vl_logic_vector;
        dout            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of num_bit : constant is 5;
end \register\;
