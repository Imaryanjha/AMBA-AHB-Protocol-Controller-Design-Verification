`timescale 1ns/1ps

module ahb_decoder
(
    input  wire [31:0] HADDR,

    output reg HSEL0,
    output reg HSEL1,
    output reg HSEL2,
    output reg HSEL3
);

always @(*)
begin

    HSEL0 = 1'b0;
    HSEL1 = 1'b0;
    HSEL2 = 1'b0;
    HSEL3 = 1'b0;

    if(HADDR >= 32'h0000_0000 &&
       HADDR <= 32'h0000_03FF)
    begin
        HSEL0 = 1'b1;
    end

    else if(HADDR >= 32'h0000_0400 &&
            HADDR <= 32'h0000_07FF)
    begin
        HSEL1 = 1'b1;
    end

    else if(HADDR >= 32'h0000_0800 &&
            HADDR <= 32'h0000_0BFF)
    begin
        HSEL2 = 1'b1;
    end

    else if(HADDR >= 32'h0000_0C00 &&
            HADDR <= 32'h0000_0FFF)
    begin
        HSEL3 = 1'b1;
    end

end

endmodule
