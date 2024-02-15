library verilog;
use verilog.vl_types.all;
entity reg_file is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        RegWrite1       : in     vl_logic;
        RegWrite2       : in     vl_logic;
        read_reg1       : in     vl_logic_vector(4 downto 0);
        read_reg2       : in     vl_logic_vector(4 downto 0);
        write_reg1      : in     vl_logic_vector(4 downto 0);
        read_reg3       : in     vl_logic_vector(4 downto 0);
        read_reg4       : in     vl_logic_vector(4 downto 0);
        write_reg2      : in     vl_logic_vector(4 downto 0);
        write_data1     : in     vl_logic_vector(31 downto 0);
        write_data2     : in     vl_logic_vector(31 downto 0);
        read_data1      : out    vl_logic_vector(31 downto 0);
        read_data2      : out    vl_logic_vector(31 downto 0);
        read_data3      : out    vl_logic_vector(31 downto 0);
        read_data4      : out    vl_logic_vector(31 downto 0)
    );
end reg_file;
