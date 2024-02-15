library verilog;
use verilog.vl_types.all;
entity data_path is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        RegDst_in       : in     vl_logic_vector(1 downto 0);
        Jmp_in          : in     vl_logic_vector(1 downto 0);
        DataC_in        : in     vl_logic;
        RegWrite_in     : in     vl_logic;
        AluSrc_in       : in     vl_logic;
        AluSrc1_in      : in     vl_logic_vector(1 downto 0);
        Branch_in       : in     vl_logic;
        bne_in          : in     vl_logic;
        MemRead_in      : in     vl_logic;
        MemWrite_in     : in     vl_logic;
        MemtoReg_in     : in     vl_logic;
        AluOperation_in : in     vl_logic_vector(5 downto 0);
        func            : out    vl_logic_vector(5 downto 0);
        opcode          : out    vl_logic_vector(5 downto 0);
        out1            : out    vl_logic_vector(31 downto 0);
        out2            : out    vl_logic_vector(31 downto 0);
        RegDst_in_ln1   : in     vl_logic_vector(1 downto 0);
        Jmp_in_ln1      : in     vl_logic_vector(1 downto 0);
        DataC_in_ln1    : in     vl_logic;
        RegWrite_in_ln1 : in     vl_logic;
        AluSrc_in_ln1   : in     vl_logic;
        AluSrc1_in_ln1  : in     vl_logic_vector(1 downto 0);
        Branch_in_ln1   : in     vl_logic;
        bne_in_ln1      : in     vl_logic;
        MemRead_in_ln1  : in     vl_logic;
        MemWrite_in_ln1 : in     vl_logic;
        MemtoReg_in_ln1 : in     vl_logic;
        AluOperation_in_ln1: in     vl_logic_vector(5 downto 0);
        func_ln1        : out    vl_logic_vector(5 downto 0);
        opcode_ln1      : out    vl_logic_vector(5 downto 0)
    );
end data_path;
