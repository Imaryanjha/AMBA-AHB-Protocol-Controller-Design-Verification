`timescale 1ns/1ps

module ahb_top
(
    input               HCLK,
    input               HRESETn,

    //------------------------------------------------------------
    // MASTER CONTROL INPUTS
    //------------------------------------------------------------
    input               enable,
    input      [31:0]   in_HADDR,
    input      [31:0]   in_HWDATA,
    input      [2:0]    in_HSIZE,
    input      [2:0]    in_HBURST,
    input               in_HWRITE,

    //------------------------------------------------------------
    // DEBUG OUTPUTS
    //------------------------------------------------------------
    output     [31:0]   dbg_HADDR,
    output     [31:0]   dbg_HWDATA,
    output     [2:0]    dbg_HSIZE,
    output     [2:0]    dbg_HBURST,
    output              dbg_HWRITE,
    output     [1:0]    dbg_HTRANS,

    output     [31:0]   dbg_HRDATA,
    output     [31:0]   dbg_OUT_HRDATA,
    output              dbg_HREADY,
    output              dbg_HRESP,

    output              dbg_HSEL0,
    output              dbg_HSEL1,
    output              dbg_HSEL2,
    output              dbg_HSEL3
);

    //------------------------------------------------------------
    // MASTER -> BUS SIGNALS
    //------------------------------------------------------------

    wire [31:0] HADDR;
    wire [31:0] HWDATA;
    wire [2:0]  HSIZE;
    wire [2:0]  HBURST;
    wire        HWRITE;
    wire [1:0]  HTRANS;

    //------------------------------------------------------------
    // DECODER OUTPUTS
    //------------------------------------------------------------

    wire HSEL0;
    wire HSEL1;
    wire HSEL2;
    wire HSEL3;

    //------------------------------------------------------------
    // SLAVE0 OUTPUTS
    //------------------------------------------------------------

    wire [31:0] HRDATA0;
    wire        HREADYOUT0;
    wire        HRESP0;

    //------------------------------------------------------------
    // SLAVE1 OUTPUTS
    //------------------------------------------------------------

    wire [31:0] HRDATA1;
    wire        HREADYOUT1;
    wire        HRESP1;

    //------------------------------------------------------------
    // SLAVE2 OUTPUTS
    //------------------------------------------------------------

    wire [31:0] HRDATA2;
    wire        HREADYOUT2;
    wire        HRESP2;

    //------------------------------------------------------------
    // SLAVE3 OUTPUTS
    //------------------------------------------------------------

    wire [31:0] HRDATA3;
    wire        HREADYOUT3;
    wire        HRESP3;

    //------------------------------------------------------------
    // MUX OUTPUTS
    //------------------------------------------------------------

    wire [31:0] HRDATA;
    wire        HREADY;
    wire        HRESP;

    //------------------------------------------------------------
    // MASTER READ DATA OUTPUT
    //------------------------------------------------------------

    wire [31:0] OUT_HRDATA;

    //------------------------------------------------------------
    // MASTER
    //------------------------------------------------------------

    ahb_master u_master
    (
        .HCLK       (HCLK),
        .HRESETn    (HRESETn),

        .enable     (enable),

        .HREADY     (HREADY),
        .HRESP      (HRESP),
        .HRDATA     (HRDATA),

        .in_HADDR   (in_HADDR),
        .in_HWDATA  (in_HWDATA),
        .in_HSIZE   (in_HSIZE),
        .in_HBURST  (in_HBURST),
        .in_HWRITE  (in_HWRITE),

        .HADDR      (HADDR),
        .HWDATA     (HWDATA),
        .HSIZE      (HSIZE),
        .HBURST     (HBURST),
        .HWRITE     (HWRITE),
        .HTRANS     (HTRANS),

        .OUT_HRDATA (OUT_HRDATA)
    );

    //------------------------------------------------------------
    // ADDRESS DECODER
    //------------------------------------------------------------

    ahb_decoder u_decoder
    (
        .HADDR (HADDR),

        .HSEL0 (HSEL0),
        .HSEL1 (HSEL1),
        .HSEL2 (HSEL2),
        .HSEL3 (HSEL3)
    );

    //------------------------------------------------------------
    // SLAVE0
    //------------------------------------------------------------

    ahb_slave
    #(
        .BASE_ADDR (32'h0000_0000),
        .END_ADDR  (32'h0000_03FF)
    )
    u_slave0
    (
        .HCLK       (HCLK),
        .HRESETn    (HRESETn),

        .HSEL       (HSEL0),

        .HADDR      (HADDR),
        .HTRANS     (HTRANS),
        .HWRITE     (HWRITE),
        .HBURST     (HBURST),
        .HWDATA     (HWDATA),

        .HRDATA     (HRDATA0),
        .HREADYOUT  (HREADYOUT0),
        .HRESP      (HRESP0)
    );

    //------------------------------------------------------------
    // SLAVE1
    //------------------------------------------------------------

    ahb_slave
    #(
        .BASE_ADDR (32'h0000_0400),
        .END_ADDR  (32'h0000_07FF)
    )
    u_slave1
    (
        .HCLK       (HCLK),
        .HRESETn    (HRESETn),

        .HSEL       (HSEL1),

        .HADDR      (HADDR),
        .HTRANS     (HTRANS),
        .HWRITE     (HWRITE),
        .HBURST     (HBURST),
        .HWDATA     (HWDATA),

        .HRDATA     (HRDATA1),
        .HREADYOUT  (HREADYOUT1),
        .HRESP      (HRESP1)
    );

    //------------------------------------------------------------
    // SLAVE2
    //------------------------------------------------------------

    ahb_slave
    #(
        .BASE_ADDR (32'h0000_0800),
        .END_ADDR  (32'h0000_0BFF)
    )
    u_slave2
    (
        .HCLK       (HCLK),
        .HRESETn    (HRESETn),

        .HSEL       (HSEL2),

        .HADDR      (HADDR),
        .HTRANS     (HTRANS),
        .HWRITE     (HWRITE),
        .HBURST     (HBURST),
        .HWDATA     (HWDATA),

        .HRDATA     (HRDATA2),
        .HREADYOUT  (HREADYOUT2),
        .HRESP      (HRESP2)
    );

    //------------------------------------------------------------
    // SLAVE3
    //------------------------------------------------------------

    ahb_slave
    #(
        .BASE_ADDR (32'h0000_0C00),
        .END_ADDR  (32'h0000_0FFF)
    )
    u_slave3
    (
        .HCLK       (HCLK),
        .HRESETn    (HRESETn),

        .HSEL       (HSEL3),

        .HADDR      (HADDR),
        .HTRANS     (HTRANS),
        .HWRITE     (HWRITE),
        .HBURST     (HBURST),
        .HWDATA     (HWDATA),

        .HRDATA     (HRDATA3),
        .HREADYOUT  (HREADYOUT3),
        .HRESP      (HRESP3)
    );	
    
    //------------------------------------------------------------
    // RESPONSE MULTIPLEXER
    //------------------------------------------------------------

    ahb_mux u_mux
    (
        .HSEL0      (HSEL0),
        .HSEL1      (HSEL1),
        .HSEL2      (HSEL2),
        .HSEL3      (HSEL3),

        .HRDATA0    (HRDATA0),
        .HRDATA1    (HRDATA1),
        .HRDATA2    (HRDATA2),
        .HRDATA3    (HRDATA3),

        .HRESP0     (HRESP0),
        .HRESP1     (HRESP1),
        .HRESP2     (HRESP2),
        .HRESP3     (HRESP3),

        .HREADYOUT0 (HREADYOUT0),
        .HREADYOUT1 (HREADYOUT1),
        .HREADYOUT2 (HREADYOUT2),
        .HREADYOUT3 (HREADYOUT3),

        .HRDATA     (HRDATA),
        .HRESP      (HRESP),
        .HREADY     (HREADY)
    );

   //------------------------------------------------------------
   // DEBUG CONNECTIONS
   //------------------------------------------------------------

assign dbg_HADDR       = HADDR;
assign dbg_HWDATA      = HWDATA;
assign dbg_HSIZE       = HSIZE;
assign dbg_HBURST      = HBURST;
assign dbg_HWRITE      = HWRITE;
assign dbg_HTRANS      = HTRANS;

assign dbg_HRDATA      = HRDATA;
assign dbg_OUT_HRDATA  = OUT_HRDATA;  
assign dbg_HREADY      = HREADY;
assign dbg_HRESP       = HRESP;

assign dbg_HSEL0       = HSEL0;
assign dbg_HSEL1       = HSEL1;
assign dbg_HSEL2       = HSEL2;
assign dbg_HSEL3       = HSEL3;

endmodule
