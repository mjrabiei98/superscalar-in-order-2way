library verilog;
use verilog.vl_types.all;
entity inst_memory is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        adr             : in     vl_logic_vector(31 downto 0);
        instruction1    : out    vl_logic_vector(31 downto 0);
        instruction2    : out    vl_logic_vector(31 downto 0)
    );
end inst_memory;
