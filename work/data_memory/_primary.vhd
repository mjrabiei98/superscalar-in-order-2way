library verilog;
use verilog.vl_types.all;
entity data_memory is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        mem_read        : in     vl_logic;
        mem_write       : in     vl_logic;
        adr             : in     vl_logic_vector(31 downto 0);
        write_data      : in     vl_logic_vector(31 downto 0);
        read_data       : out    vl_logic_vector(31 downto 0);
        out1            : out    vl_logic_vector(31 downto 0);
        out2            : out    vl_logic_vector(31 downto 0)
    );
end data_memory;
