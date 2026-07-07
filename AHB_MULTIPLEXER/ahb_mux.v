
`timescale 1ns/1ps

module ahb_mux
(
    input  wire        HSEL0,
    input  wire        HSEL1,
    input  wire        HSEL2,
    input  wire        HSEL3,

    input  wire [31:0] HRDATA0,
    input  wire [31:0] HRDATA1,
    input  wire [31:0] HRDATA2,
    input  wire [31:0] HRDATA3,

    input  wire        HRESP0,
    input  wire        HRESP1,
    input  wire        HRESP2,
    input  wire        HRESP3,

    input  wire        HREADYOUT0,
    input  wire        HREADYOUT1,
    input  wire        HREADYOUT2,
    input  wire        HREADYOUT3,

    output reg  [31:0] HRDATA,
    output reg         HRESP,
    output reg         HREADY
);

always @(*)
begin

    HRDATA = 32'h0;
    HRESP  = 1'b0;
    HREADY = 1'b1;

    if(HSEL0)
    begin
        HRDATA = HRDATA0;
        HRESP  = HRESP0;
        HREADY = HREADYOUT0;
    end

    else if(HSEL1)
    begin
        HRDATA = HRDATA1;
        HRESP  = HRESP1;
        HREADY = HREADYOUT1;
    end

    else if(HSEL2)
    begin
        HRDATA = HRDATA2;
        HRESP  = HRESP2;
        HREADY = HREADYOUT2;
    end

    else if(HSEL3)
    begin
        HRDATA = HRDATA3;
        HRESP  = HRESP3;
        HREADY = HREADYOUT3;
    end

end

endmodule
