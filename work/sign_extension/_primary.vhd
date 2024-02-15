library verilog;
use verilog.vl_types.all;
entity sign_extension is
    port(
        clk             : in     vl_logic;
        primary         : in     vl_logic_vector(15 downto 0);
        extended        : out    vl_logic_vector(31 downto 0)
    );
end sign_extension;
