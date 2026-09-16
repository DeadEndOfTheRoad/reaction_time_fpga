module delay_counter(
        input  logic        clk, reset, en,
        output logic [29:0] counter_value
    );
    
    logic [29:0] value;
    
    always_ff @(posedge clk) begin
        if (reset) value <= 0;
        else if (en) value <= value + 1;
    end
    
    assign counter_value = value;
endmodule
