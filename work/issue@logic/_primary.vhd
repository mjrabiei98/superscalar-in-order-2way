library verilog;
use verilog.vl_types.all;
entity issueLogic is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        instruction_D1  : in     vl_logic_vector(31 downto 0);
        instruction_E1  : in     vl_logic_vector(31 downto 0);
        instruction_M1  : in     vl_logic_vector(31 downto 0);
        instruction_WB1 : in     vl_logic_vector(31 downto 0);
        branch          : in     vl_logic;
        jmp             : in     vl_logic_vector(1 downto 0);
        instruction_D2  : in     vl_logic_vector(31 downto 0);
        instruction_E2  : in     vl_logic_vector(31 downto 0);
        instruction_M2  : in     vl_logic_vector(31 downto 0);
        instruction_WB2 : in     vl_logic_vector(31 downto 0);
        stall           : out    vl_logic;
        stall_outer_dependent: out    vl_logic;
        flush           : out    vl_logic;
        swap1           : out    vl_logic_vector(1 downto 0);
        swap2           : out    vl_logic_vector(1 downto 0)
    );
end issueLogic;
