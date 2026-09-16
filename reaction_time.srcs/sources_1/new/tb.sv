module tb;
    logic clk, reset, lfsr_reset, btn;
    logic [1:0] rgb_led; // {red, green}
    logic [3:0] AN;
    logic [7:0] SEG;
    
    top dut(clk, reset, lfsr_reset, btn, rgb_led, AN, SEG);
    
    always begin       
        clk <= 0; #5;
        clk <= 1; #5;
    end
    
    initial begin
        reset = 1; lfsr_reset = 1; btn = 0;
        #10;
        reset = 0; lfsr_reset = 0;
        #10;
    end

endmodule