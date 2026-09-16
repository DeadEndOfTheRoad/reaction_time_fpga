module bcd16_to_7seg32 (
    input  logic [3:0] bcd3, // thousands
    input  logic [3:0] bcd2, // hundreds
    input  logic [3:0] bcd1, // tens
    input  logic [3:0] bcd0, // ones
    output logic [31:0] seg_bus
);

    function automatic logic [7:0] seg(input logic [3:0] d);
        case (d)
            4'd0: seg = 8'b11000000;
            4'd1: seg = 8'b11111001;
            4'd2: seg = 8'b10100100;
            4'd3: seg = 8'b10110000;
            4'd4: seg = 8'b10011001;
            4'd5: seg = 8'b10010010;
            4'd6: seg = 8'b10000010;
            4'd7: seg = 8'b11111000;
            4'd8: seg = 8'b10000000;
            4'd9: seg = 8'b10010000;
            default: seg = 8'b11111111; // blank
        endcase
    endfunction

    assign seg_bus = {
        seg(bcd3),
        seg(bcd2),
        seg(bcd1),
        seg(bcd0)
    };

endmodule