library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        clk             : in     vl_logic;
        data1           : in     vl_logic_vector(31 downto 0);
        data2           : in     vl_logic_vector(31 downto 0);
        alu_op          : in     vl_logic_vector(5 downto 0);
        alu_result      : out    vl_logic_vector(31 downto 0);
        zero_flag       : out    vl_logic
    );
end alu;
