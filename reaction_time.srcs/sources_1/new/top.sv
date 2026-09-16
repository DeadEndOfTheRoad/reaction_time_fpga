module top(
        input  logic       clk, reset, lfsr_reset, btn,
        output logic [1:0] rgb_led, // {red, green}
        output logic [3:0] AN,
        output logic [7:0] SEG
    );
    
    logic        lfsr_en, rxn_time_en, delay_en;
    logic [29:0] target_delay, counter_value;
    logic [15:0] number;
    logic [12:0] rxn_time;
    logic [7:0]  valid_segments [0:3];
    logic [7:0]  segments [0:3];
    logic [3:0]  bcd [0:3];
    
    assign target_delay = 30'h08000000 + (number << 13);
    
    lfsr lfsr_module(
        clk,
        lfsr_reset,
        lfsr_en,
        number
    );
    
    segment segment_module(
        reset,
        clk,
        segments,
        AN,
        SEG
    );
    
    rxn_time_counter rxn_time_counter_module(
        clk,
        reset,
        rxn_time_en,
        rxn_time
    );
    
    delay_counter delay_counter_module(
        clk,
        reset,
        delay_en,
        counter_value
    );
    
    bin_to_bcd_13 bin2bcd_module(
        rxn_time,
        bcd[3],
        bcd[2],
        bcd[1],
        bcd[0]
    );
    
    bcd16_to_7seg32 bcd2seg_module(
        bcd[3],
        bcd[2],
        bcd[1],
        bcd[0],
        {valid_segments[3], valid_segments[2], valid_segments[1], valid_segments[0]}        
    );
    
    logic [1:0] state, next_state;
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
        end else begin
            state <= next_state;
        end
    end
    
    always_comb begin
        rgb_led = 2'b00;
        lfsr_en = 1;
        rxn_time_en = 0;
        delay_en = 0;
        segments = '{default: 8'hFF};
        next_state = 2'b00;    
        case (state) 
          2'b00: begin // IDLE STATE
            rgb_led = 2'b00;
            lfsr_en = 1;
            rxn_time_en = 0;
            delay_en = 0;
            segments = '{default: 8'hFF};
            next_state = 2'b01;
          end
          2'b01: begin // WAITING STATE
            rgb_led = 2'b10;
            lfsr_en = 0;
            rxn_time_en = 0;
            delay_en = 1;
            segments = '{default: 8'hFF};
            if (counter_value >= target_delay)
                next_state = 2'b10;
            else
                next_state = 2'b01;
          end
          2'b10: begin // GO STATE
            rgb_led = 2'b01;
            lfsr_en = 0;
            rxn_time_en = 1;
            delay_en = 0;
            segments = '{default: 8'hFF};
            if (btn)
                next_state = 2'b11;
            else
                next_state = 2'b10;
          end
          2'b11: begin // DONE STATE
            rgb_led = 2'b00;
            lfsr_en = 1;
            rxn_time_en = 0;
            delay_en = 0;
            segments = valid_segments;
            next_state = 2'b11; // Process finished, need to press reset button to start game again
          end
          default: next_state = 2'b00;
        endcase
    end
    
    
endmodule
