module lfsr( 
    input  logic        clk, lfsr_reset, en,
    output logic [15:0] number
    );
    
    // Random number changes every 10 nanoseconds
    logic [15:0] rand_num;
    
    always_ff @(posedge clk or posedge lfsr_reset) begin
        if (lfsr_reset) begin
            rand_num <= 16'h4FA3; // A 16 bit seed that won't lock up
        end else if (en) begin
            rand_num <= {rand_num[15] ^ rand_num[13] ^ rand_num[12] ^ rand_num[10], rand_num[15:1]};
        end
    end
    
    assign number = rand_num;
    
endmodule
