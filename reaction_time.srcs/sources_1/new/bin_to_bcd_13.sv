module bin_to_bcd_13 (
    input  logic [12:0] bin,
    output logic [3:0]  bcd3,
    output logic [3:0]  bcd2,
    output logic [3:0]  bcd1,
    output logic [3:0]  bcd0
);
    logic [28:0] shift; // 13 binary + 16 BCD = 29 bits
    always_comb begin
        shift = 29'b0;
        shift[12:0] = bin;
        for (int i = 0; i < 13; i++) begin
            if (shift[28:25] >= 5) shift[28:25] += 3;
            if (shift[24:21] >= 5) shift[24:21] += 3;
            if (shift[20:17] >= 5) shift[20:17] += 3;
            if (shift[16:13] >= 5) shift[16:13] += 3;
            shift = shift << 1;
        end
    end
    assign bcd3 = shift[28:25];
    assign bcd2 = shift[24:21];
    assign bcd1 = shift[20:17];
    assign bcd0 = shift[16:13];
endmodule