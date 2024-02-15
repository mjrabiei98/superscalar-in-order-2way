library verilog;
use verilog.vl_types.all;
entity controller is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        opcode          : in     vl_logic_vector(5 downto 0);
        func            : in     vl_logic_vector(5 downto 0);
        RegDst          : out    vl_logic_vector(1 downto 0);
        Jmp             : out    vl_logic_vector(1 downto 0);
        DataC           : out    vl_logic;
        Regwrite        : out    vl_logic;
        AluSrc          : out    vl_logic;
        AluSrc1         : out    vl_logic_vector(1 downto 0);
        Branch          : out    vl_logic;
        bne             : out    vl_logic;
        MemRead         : out    vl_logic;
        MemWrite        : out    vl_logic;
        MemtoReg        : out    vl_logic;
        AluOperation    : out    vl_logic_vector(5 downto 0)
    );
end controller;
