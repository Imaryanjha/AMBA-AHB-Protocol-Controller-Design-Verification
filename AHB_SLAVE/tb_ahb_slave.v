`timescale 1ns/1ps

module tb_ahb_burst;

reg         HCLK;
reg         HRESETn;

reg         HSEL;
reg [31:0]  HADDR;
reg [1:0]   HTRANS;
reg         HWRITE;
reg [2:0]   HBURST;
reg [31:0]  HWDATA;

wire [31:0] HRDATA;
wire        HREADYOUT;
wire        HRESP;

integer pass_count;
integer fail_count;

ahb_slave dut
(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HSEL(HSEL),
    .HADDR(HADDR),
    .HTRANS(HTRANS),
    .HWRITE(HWRITE),
    .HBURST(HBURST),
    .HWDATA(HWDATA),
    .HRDATA(HRDATA),
    .HREADYOUT(HREADYOUT),
    .HRESP(HRESP)
);

////////////////////////////////////////////////////////////
// Clock
////////////////////////////////////////////////////////////

initial
begin
    HCLK = 0;
    forever #5 HCLK = ~HCLK;
end

////////////////////////////////////////////////////////////
// Reset
////////////////////////////////////////////////////////////

initial
begin
    HRESETn = 0;

    HSEL    = 0;
    HADDR   = 0;
    HTRANS  = 2'b00;
    HWRITE  = 0;
    HBURST  = 3'b000;
    HWDATA  = 0;

    pass_count = 0;
    fail_count = 0;

    #20;
    HRESETn = 1;

    #20;

    single_write_read();

    incr4_write();
    incr4_read();

    wrap4_write();
    wrap4_read();

    error_test();

    #50;

    $display("=================================");
    $display("PASS = %0d", pass_count);
    $display("FAIL = %0d", fail_count);
    $display("=================================");

    $finish;
end

////////////////////////////////////////////////////////////
// SINGLE WRITE
////////////////////////////////////////////////////////////

task single_write_read;
begin

    $display("\n===== SINGLE WRITE/READ =====");

    @(posedge HCLK);

    HSEL   = 1;
    HWRITE = 1;
    HADDR  = 32'h00000020;
    HBURST = 3'b000;
    HTRANS = 2'b10;
    HWDATA = 32'hDEADBEEF;

    @(posedge HCLK);

    HWRITE = 0;
    HADDR  = 32'h00000020;
    HTRANS = 2'b10;

    @(posedge HCLK);

    if(HRDATA == 32'hDEADBEEF)
    begin
        $display("PASS SINGLE READ");
        pass_count++;
    end
    else
    begin
        $display("FAIL SINGLE READ");
        fail_count++;
    end

    HSEL   = 0;
    HTRANS = 2'b00;

end
endtask

////////////////////////////////////////////////////////////
// INCR4 WRITE
////////////////////////////////////////////////////////////

task incr4_write;
integer i;
begin

    $display("\n===== INCR4 WRITE =====");

    HSEL   = 1;
    HWRITE = 1;
    HBURST = 3'b011;

    for(i=0;i<4;i=i+1)
    begin
        @(posedge HCLK);

        HADDR  = 32'h00000040 + (i*4);
        HWDATA = 32'h11110000 + i;

        if(i==0)
            HTRANS = 2'b10;
        else
            HTRANS = 2'b11;
    end

    @(posedge HCLK);

    HSEL   = 0;
    HTRANS = 2'b00;

end
endtask

////////////////////////////////////////////////////////////
// INCR4 READ
////////////////////////////////////////////////////////////

task incr4_read;
integer i;
reg [31:0] expected;
begin

    $display("\n===== INCR4 READ =====");

    HSEL   = 1;
    HWRITE = 0;
    HBURST = 3'b011;

    for(i=0;i<4;i=i+1)
    begin
        @(posedge HCLK);

        HADDR = 32'h00000040 + (i*4);

        if(i==0)
            HTRANS = 2'b10;
        else
            HTRANS = 2'b11;

        @(posedge HCLK);

        expected = 32'h11110000 + i;

        if(HRDATA == expected)
        begin
            $display("PASS INCR4 READ[%0d] = %h",i,HRDATA);
            pass_count++;
        end
        else
        begin
            $display("FAIL INCR4 READ[%0d] Expected=%h Got=%h",
                     i,expected,HRDATA);
            fail_count++;
        end
    end

    HSEL   = 0;
    HTRANS = 2'b00;

end
endtask

////////////////////////////////////////////////////////////
// WRAP4 WRITE
////////////////////////////////////////////////////////////

task wrap4_write;
begin

    $display("\n===== WRAP4 WRITE =====");

    HSEL   = 1;
    HWRITE = 1;
    HBURST = 3'b010;

    @(posedge HCLK);
    HADDR  = 32'h0000000C;
    HWDATA = 32'hAAAA0001;
    HTRANS = 2'b10;

    @(posedge HCLK);
    HADDR  = 32'h00000000;
    HWDATA = 32'hAAAA0002;
    HTRANS = 2'b11;

    @(posedge HCLK);
    HADDR  = 32'h00000004;
    HWDATA = 32'hAAAA0003;
    HTRANS = 2'b11;

    @(posedge HCLK);
    HADDR  = 32'h00000008;
    HWDATA = 32'hAAAA0004;
    HTRANS = 2'b11;

    @(posedge HCLK);

    HSEL   = 0;
    HTRANS = 2'b00;

end
endtask

////////////////////////////////////////////////////////////
// WRAP4 READ
////////////////////////////////////////////////////////////

task wrap4_read;
reg [31:0] data_exp [0:3];
integer i;

begin

    data_exp[0] = 32'hAAAA0001;
    data_exp[1] = 32'hAAAA0002;
    data_exp[2] = 32'hAAAA0003;
    data_exp[3] = 32'hAAAA0004;

    $display("\n===== WRAP4 READ =====");

    HSEL   = 1;
    HWRITE = 0;
    HBURST = 3'b010;

    @(posedge HCLK);
    HADDR  = 32'h0000000C;
    HTRANS = 2'b10;
    @(posedge HCLK);

    if(HRDATA == data_exp[0]) pass_count++;
    else fail_count++;

    @(posedge HCLK);
    HADDR  = 32'h00000000;
    HTRANS = 2'b11;
    @(posedge HCLK);

    if(HRDATA == data_exp[1]) pass_count++;
    else fail_count++;

    @(posedge HCLK);
    HADDR  = 32'h00000004;
    HTRANS = 2'b11;
    @(posedge HCLK);

    if(HRDATA == data_exp[2]) pass_count++;
    else fail_count++;

    @(posedge HCLK);
    HADDR  = 32'h00000008;
    HTRANS = 2'b11;
    @(posedge HCLK);

    if(HRDATA == data_exp[3]) pass_count++;
    else fail_count++;

    HSEL   = 0;
    HTRANS = 2'b00;

end
endtask

////////////////////////////////////////////////////////////
// ERROR TEST
////////////////////////////////////////////////////////////

task error_test;
begin

    $display("\n===== ERROR TEST =====");

    @(posedge HCLK);

    HSEL   = 1;
    HWRITE = 1;
    HBURST = 3'b000;
    HTRANS = 2'b10;
    HADDR  = 32'h00001000;

    @(posedge HCLK);

    if(HRESP)
    begin
        $display("PASS ERROR RESPONSE");
        pass_count++;
    end
    else
    begin
        $display("FAIL ERROR RESPONSE");
        fail_count++;
    end

    HSEL   = 0;
    HTRANS = 2'b00;

end
endtask

initial begin
    $dumpfile("ahb_burst.vcd");
    $dumpvars(0, tb_ahb_burst);
end

endmodule
