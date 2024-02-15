library verilog;
use verilog.vl_types.all;
entity adder is
    port(
        clk             : in     vl_logic;
        data1           : in     vl_logic_vector(31 downto 0);
        data2           : in     vl_logic_vector(31 downto 0);
        sum             : out    vl_logic_vector(31 downto 0)
    );
end adder;
