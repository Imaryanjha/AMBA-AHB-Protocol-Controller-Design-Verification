`timescale 1ns/1ps

module tb_ahb_decoder;

reg  [31:0] HADDR;

wire HSEL0;
wire HSEL1;
wire HSEL2;
wire HSEL3;

integer pass_count;
integer fail_count;

ahb_decoder dut
(
    .HADDR(HADDR),

    .HSEL0(HSEL0),
    .HSEL1(HSEL1),
    .HSEL2(HSEL2),
    .HSEL3(HSEL3)
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

    HADDR = 32'h0000_1234;
    #10;

    check(
          HSEL0 && !HSEL1 && !HSEL2 && !HSEL3,
          "Slave0 Select"
         );

    //-------------------------------------------------
    // Slave1
    //-------------------------------------------------

    HADDR = 32'h1000_5678;
    #10;

    check(
          !HSEL0 && HSEL1 && !HSEL2 && !HSEL3,
          "Slave1 Select"
         );

    //-------------------------------------------------
    // Slave2
    //-------------------------------------------------

    HADDR = 32'h2000_ABCD;
    #10;

    check(
          !HSEL0 && !HSEL1 && HSEL2 && !HSEL3,
          "Slave2 Select"
         );

    //-------------------------------------------------
    // Slave3
    //-------------------------------------------------

    HADDR = 32'h3000_1111;
    #10;

    check(
          !HSEL0 && !HSEL1 && !HSEL2 && HSEL3,
          "Slave3 Select"
         );

    //-------------------------------------------------
    // Invalid Address
    //-------------------------------------------------

    HADDR = 32'h8000_0000;
    #10;

    check(
          !HSEL0 && !HSEL1 && !HSEL2 && !HSEL3,
          "Invalid Address"
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
    $dumpfile("decoder.vcd");
    $dumpvars(0, tb_ahb_decoder);
end

endmodule
