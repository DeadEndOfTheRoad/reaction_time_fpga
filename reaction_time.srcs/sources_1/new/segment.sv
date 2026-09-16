module segment(
    input  logic       reset,
    input  logic       clk,
    input  logic [7:0] segments [0:3],
    output logic [3:0] AN,
    output logic [7:0] SEG
);

    logic [17:0] clk_divider;
    logic [1:0] select_digit;
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_divider <= 18'b000_000_000_000_000_000;
            select_digit <= 2'b00;
        end else begin
            clk_divider <= clk_divider + 1;
            if (clk_divider == 18'b111_111_111_111_111_111)
                select_digit <= select_digit + 1;
        end      
    end
    
    assign SEG = segments[select_digit];
    assign AN = ~(1 << select_digit);       

endmodule