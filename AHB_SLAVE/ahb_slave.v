`timescale 1ns/1ps

module ahb_slave
#(
    parameter BASE_ADDR = 32'h0000_0000,
    parameter END_ADDR  = 32'h0000_03FF
)
(
    input              HCLK,
    input              HRESETn,

    input              HSEL,
    input      [31:0]  HADDR,
    input      [1:0]   HTRANS,
    input              HWRITE,
    input      [2:0]   HBURST,
    input      [31:0]  HWDATA,

    output reg [31:0]  HRDATA,
    output reg         HREADYOUT,
    output reg         HRESP
);

    //------------------------------------------------------------
    // State Encoding
    //------------------------------------------------------------

    localparam IDLE        = 3'b000,
               READ_STATE  = 3'b001,
               WRITE_STATE = 3'b010,
               BURST_STATE = 3'b011,
               ERROR_STATE = 3'b100;

    //------------------------------------------------------------
    // State Registers
    //------------------------------------------------------------

    reg [2:0] current_state;
    reg [2:0] next_state;

    //------------------------------------------------------------
    // Memory
    //------------------------------------------------------------

    reg [31:0] mem [0:255];

    //------------------------------------------------------------
    // Burst Counter
    //------------------------------------------------------------

    reg [1:0] burst_count;

    //------------------------------------------------------------
    // Internal Signals
    //------------------------------------------------------------

    wire valid_transfer;
    wire burst_mode;
    wire addr_error;

    wire [31:0] local_addr;

    assign valid_transfer = HSEL && HTRANS[1];

    assign burst_mode =
           (HBURST == 3'b010) ||   // WRAP4
           (HBURST == 3'b011);     // INCR4

    assign addr_error =
           (HADDR < BASE_ADDR) ||
           (HADDR > END_ADDR);

    assign local_addr =
           (HADDR - BASE_ADDR) >> 2;

    //------------------------------------------------------------
    // State Register
    //------------------------------------------------------------

    always @(posedge HCLK or negedge HRESETn)
    begin
        if(!HRESETn)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    //------------------------------------------------------------
    // Next State Logic
    //------------------------------------------------------------

    always @(*)
    begin
        next_state = current_state;

        case(current_state)

            //----------------------------------------------------
            // IDLE
            //----------------------------------------------------

            IDLE:
            begin
                if(valid_transfer)
                begin
                    if(addr_error)
                        next_state = ERROR_STATE;
                    else if(HWRITE)
                        next_state = WRITE_STATE;
                    else
                        next_state = READ_STATE;
                end
            end

            //----------------------------------------------------
            // WRITE
            //----------------------------------------------------

            WRITE_STATE:
            begin
                if(burst_mode)
                    next_state = BURST_STATE;
                else
                    next_state = IDLE;
            end

            //----------------------------------------------------
            // READ
            //----------------------------------------------------

            READ_STATE:
            begin
                if(burst_mode)
                    next_state = BURST_STATE;
                else
                    next_state = IDLE;
            end

            //----------------------------------------------------
            // BURST
            //----------------------------------------------------

            BURST_STATE:
            begin
                if(addr_error)
                    next_state = ERROR_STATE;

                else if(burst_count == 2'd3)
                    next_state = IDLE;

                else
                    next_state = BURST_STATE;
            end

            //----------------------------------------------------
            // ERROR
            //----------------------------------------------------

            ERROR_STATE:
            begin
                next_state = IDLE;
            end

            default:
                next_state = IDLE;

        endcase
    end

    //------------------------------------------------------------
    // Burst Counter
    //------------------------------------------------------------

    always @(posedge HCLK or negedge HRESETn)
    begin
        if(!HRESETn)
            burst_count <= 2'd0;

        else if(current_state == IDLE)
            burst_count <= 2'd0;

        else if(current_state == BURST_STATE &&
                valid_transfer)
            burst_count <= burst_count + 1'b1;
    end

    //------------------------------------------------------------
    // Memory Write
    //------------------------------------------------------------

    always @(posedge HCLK)
begin
    if(HRESETn)
    begin
        if(valid_transfer &&
           HWRITE &&
           !addr_error)
        begin
            mem[local_addr] <= HWDATA;
        end
    end
end

    //------------------------------------------------------------
// Memory Read
//------------------------------------------------------------

always @(*)
begin
    if(valid_transfer &&
       !HWRITE &&
       !addr_error)
    begin
        HRDATA = mem[local_addr];
    end
    else
    begin
        HRDATA = 32'h00000000;
    end
end

    //------------------------------------------------------------
    // Response Logic
    //------------------------------------------------------------

    always @(*)
    begin

        HREADYOUT = 1'b1;

        if(valid_transfer && addr_error)
            HRESP = 1'b1;
        else
            HRESP = 1'b0;

    end

    //------------------------------------------------------------
    // Memory Initialization
    //------------------------------------------------------------

    integer i;

    initial
    begin

        for(i=0;i<256;i=i+1)
            mem[i] = 32'h00000000;

    end

endmodule
