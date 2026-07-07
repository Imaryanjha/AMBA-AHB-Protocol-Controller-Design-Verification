`timescale 1ns/1ps

module ahb_master (

input               HCLK,
input               HRESETn,

// Transaction Request
input               enable,
input               HREADY,
input               HRESP,
input       [31:0]  HRDATA,

input       [31:0]  in_HADDR,
input       [31:0]  in_HWDATA,
input       [2:0]   in_HSIZE,
input       [2:0]   in_HBURST,
input               in_HWRITE,

// Bus Outputs
output reg  [31:0]  HADDR,
output reg  [31:0]  HWDATA,
output reg  [2:0]   HSIZE,
output reg  [2:0]   HBURST,
output reg          HWRITE,
output reg  [1:0]   HTRANS,

output reg  [31:0]  OUT_HRDATA

);

//------------------------------------------------------------
// State Encoding
//------------------------------------------------------------

localparam IDLE        = 3'b000,
           ADDR_PHASE  = 3'b001,
           DATA_PHASE  = 3'b010,
           WAIT_STATE  = 3'b011,
           BURST       = 3'b100,
           ERROR_STATE = 3'b101;

//------------------------------------------------------------
// State Registers
//------------------------------------------------------------

reg [2:0] current_state;
reg [2:0] next_state;

//------------------------------------------------------------
// Transaction Registers
//------------------------------------------------------------

reg [31:0] addr_reg;
reg [31:0] wdata_reg;
reg [2:0]  hsize_reg;
reg [2:0]  hburst_reg;
reg         hwrite_reg;

//------------------------------------------------------------
// Burst Registers
//------------------------------------------------------------

reg [31:0] burst_addr;
reg [1:0]  burst_count;

wire burst_mode;
wire [31:0] wrap_base;

assign burst_mode =
       (hburst_reg == 3'b010) ||
       (hburst_reg == 3'b011);

assign wrap_base = addr_reg & 32'hFFFF_FFF0;

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
// Transaction Capture
//------------------------------------------------------------

always @(posedge HCLK or negedge HRESETn)
begin

    if(!HRESETn)
    begin
        addr_reg   <= 32'd0;
        wdata_reg  <= 32'd0;
        hsize_reg  <= 3'd0;
        hburst_reg <= 3'd0;
        hwrite_reg <= 1'b0;
    end

    else if(current_state == ADDR_PHASE)
    begin
        addr_reg   <= in_HADDR;
        wdata_reg  <= in_HWDATA;
        hsize_reg  <= in_HSIZE;
        hburst_reg <= in_HBURST;
        hwrite_reg <= in_HWRITE;
    end

end

//------------------------------------------------------------
// Burst Engine
//------------------------------------------------------------

always @(posedge HCLK or negedge HRESETn)
begin

    if(!HRESETn)
    begin
        burst_addr  <= 32'd0;
        burst_count <= 2'd0;
    end

    else
    begin

        if(current_state == ADDR_PHASE)
        begin
            burst_addr  <= in_HADDR + 4;
            burst_count <= 2'd0;
        end

        else if(current_state == BURST &&
                HREADY &&
                !HRESP)
        begin

            burst_count <= burst_count + 1'b1;

            case(hburst_reg)

                // INCR4
                3'b011:
                    burst_addr <= burst_addr + 4;

                // WRAP4
                3'b010:
                begin

                    if((burst_addr + 4) >= (wrap_base + 16))
                        burst_addr <= wrap_base;
                    else
                        burst_addr <= burst_addr + 4;

                end

                default:
                    burst_addr <= burst_addr;

            endcase

        end

    end

end

//------------------------------------------------------------
// Next State Logic
//------------------------------------------------------------

always @(*)
begin

    next_state = current_state;

    case(current_state)

        IDLE:
        begin
            if(enable)
                next_state = ADDR_PHASE;
        end

        ADDR_PHASE:
        begin
            next_state = DATA_PHASE;
        end

        DATA_PHASE:
        begin

            if(HRESP)
                next_state = ERROR_STATE;

            else if(!HREADY)
                next_state = WAIT_STATE;

            else if(burst_mode)
                next_state = BURST;

            else
                next_state = IDLE;

        end

        WAIT_STATE:
        begin

            if(HRESP)
                next_state = ERROR_STATE;

            else if(HREADY)
            begin

                if(burst_mode)
                    next_state = BURST;
                else
                    next_state = IDLE;

            end

        end

        BURST:
        begin

            if(HRESP)
                next_state = ERROR_STATE;

            else if(!HREADY)
                next_state = WAIT_STATE;

            else if(burst_count == 2'd3)
                next_state = IDLE;

            else
                next_state = BURST;

        end

        ERROR_STATE:
        begin
            next_state = IDLE;
        end

        default:
            next_state = IDLE;

    endcase

end

//------------------------------------------------------------
// Output Logic
//------------------------------------------------------------

always @(*)
begin

    HADDR  = 32'd0;
    HWDATA = 32'd0;
    HSIZE  = 3'd0;
    HBURST = 3'd0;
    HWRITE = 1'b0;
    HTRANS = 2'b00;

    case(current_state)

        IDLE:
        begin
            HTRANS = 2'b00;
        end

        ADDR_PHASE:
        begin

            HADDR  = in_HADDR;
            HSIZE  = in_HSIZE;
            HBURST = in_HBURST;
            HWRITE = in_HWRITE;

            HTRANS = 2'b10;

        end

        DATA_PHASE:
        begin

            HADDR  = addr_reg;
            HSIZE  = hsize_reg;
            HBURST = hburst_reg;
            HWRITE = hwrite_reg;

            HTRANS = 2'b10;

            if(hwrite_reg)
                HWDATA = wdata_reg;

        end

        WAIT_STATE:
        begin

            if(burst_mode)
                HADDR = burst_addr;
            else
                HADDR = addr_reg;

            HSIZE  = hsize_reg;
            HBURST = hburst_reg;
            HWRITE = hwrite_reg;

            if(burst_mode)
                HTRANS = 2'b11;
            else
                HTRANS = 2'b10;

            if(hwrite_reg)
                HWDATA = wdata_reg;

        end

        BURST:
        begin

            HADDR  = burst_addr;
            HSIZE  = hsize_reg;
            HBURST = hburst_reg;
            HWRITE = hwrite_reg;

            HTRANS = 2'b11;

            if(hwrite_reg)
                HWDATA = wdata_reg;

        end

        ERROR_STATE:
        begin
            HTRANS = 2'b00;
        end

        default:
        begin
            HTRANS = 2'b00;
        end

    endcase

end

//------------------------------------------------------------
// Read Data Capture
//------------------------------------------------------------

always @(posedge HCLK or negedge HRESETn)
begin

    if(!HRESETn)
        OUT_HRDATA <= 32'd0;

    else if((current_state == DATA_PHASE ||
             current_state == BURST) &&
            !hwrite_reg &&
            HREADY &&
            !HRESP)
    begin
        OUT_HRDATA <= HRDATA;
    end

end

endmodule
