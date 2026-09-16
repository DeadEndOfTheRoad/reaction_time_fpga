module rxn_time_counter(
        input  logic        clk, counter_reset, en,
        output logic [12:0] rxn_time
    );
    
    logic [12:0] time_ms;
    logic [16:0] divider;
    
    always_ff @(posedge clk) begin
        if (counter_reset) begin
            divider <= 0;
            time_ms <= 0;
        end else if (en) begin
            if (divider == 17'd99_999) begin
                time_ms <= time_ms + 1;
                divider <= 17'b0;
            end else begin
                divider <= divider + 1;
            end
        end
    end
    
    assign rxn_time = time_ms;
    
    
endmodule
