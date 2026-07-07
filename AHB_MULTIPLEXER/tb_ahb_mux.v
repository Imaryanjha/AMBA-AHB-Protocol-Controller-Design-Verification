`timescale 1ns/1ps

module tb_ahb_mux;

reg HSEL0;
reg HSEL1;
reg HSEL2;
reg HSEL3;

reg [31:0] HRDATA0;
reg [31:0] HRDATA1;
reg [31:0] HRDATA2;
reg [31:0] HRDATA3;

reg HRESP0;
reg HRESP1;
reg HRESP2;
reg HRESP3;

reg HREADYOUT0;
reg HREADYOUT1;
reg HREADYOUT2;
reg HREADYOUT3;

wire [31:0] HRDATA;
wire HRESP;
wire HREADY;

integer pass_count;
integer fail_count;

ahb_mux dut
(
    .HSEL0(HSEL0),
    .HSEL1(HSEL1),
    .HSEL2(HSEL2),
    .HSEL3(HSEL3),

    .HRDATA0(HRDATA0),
    .HRDATA1(HRDATA1),
    .HRDATA2(HRDATA2),
    .HRDATA3(HRDATA3),

    .HRESP0(HRESP0),
    .HRESP1(HRESP1),
    .HRESP2(HRESP2),
    .HRESP3(HRESP3),

    .HREADYOUT0(HREADYOUT0),
    .HREADYOUT1(HREADYOUT1),
    .HREADYOUT2(HREADYOUT2),
    .HREADYOUT3(HREADYOUT3),

    .HRDATA(HRDATA),
    .HRESP(HRESP),
    .HREADY(HREADY)
);

task check;
input condition;
input [255:0] msg;
begin
    if(condition)
    begin
        pass_count = pass_count + 1;
        $display("PASS : %0s",msg);
    end
    else
    begin
        fail_count = fail_count + 1;
        $display("FAIL : %0s",msg);
    end
end
endtask

initial
begin

    pass_count = 0;
    fail_count = 0;

    //-------------------------------------------------
    // Slave0
    //-------------------------------------------------

    HSEL0 = 1;
    HSEL1 = 0;
    HSEL2 = 0;
    HSEL3 = 0;

    HRDATA0 = 32'hAAAA_AAAA;
    HRESP0 = 0;
    HREADYOUT0 = 1;

    #10;

    check(
          HRDATA == 32'hAAAA_AAAA,
          "Slave0 Data"
         );

    //-------------------------------------------------
    // Slave1
    //-------------------------------------------------

    HSEL0 = 0;
    HSEL1 = 1;

    HRDATA1 = 32'hBBBB_BBBB;

    #10;

    check(
          HRDATA == 32'hBBBB_BBBB,
          "Slave1 Data"
         );

    //-------------------------------------------------
    // Slave2 Error
    //-------------------------------------------------

    HSEL1 = 0;
    HSEL2 = 1;

    HRDATA2 = 32'hCCCC_CCCC;
    HRESP2 = 1;

    #10;

    check(
          HRESP == 1,
          "Error Propagation"
         );

    //-------------------------------------------------
    // Slave3 Wait
    //-------------------------------------------------

    HSEL2 = 0;
    HSEL3 = 1;

    HREADYOUT3 = 0;

    #10;

    check(
          HREADY == 0,
          "Wait State Propagation"
         );

    //-------------------------------------------------

    $display("\n======================");
    $display("PASS = %0d",pass_count);
    $display("FAIL = %0d",fail_count);
    $display("======================");

    $finish;

end

initial
begin
    $dumpfile("mux.vcd");
    $dumpvars(0, tb_ahb_mux);
end

endmodule

