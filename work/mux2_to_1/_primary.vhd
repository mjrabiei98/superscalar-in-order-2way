library verilog;
use verilog.vl_types.all;
entity mux2_to_1 is
    generic(
        num_bit         : vl_notype
    );
    port(
        clk             : in     vl_logic;
        data1           : in     vl_logic_vector;
        data2           : in     vl_logic_vector;
        sel             : in     vl_logic;
        \out\           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of num_bit : constant is 5;
end mux2_to_1;
