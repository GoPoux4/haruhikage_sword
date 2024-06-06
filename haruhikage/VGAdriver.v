`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:06:36 12/28/2023 
// Design Name: 
// Module Name:    VGAdriver 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VGAdriver(
    input wire clk,            // 25 MHz
    input wire rst,
    input wire [11:0] D_in,    // RGB, pixel
    output reg [9:0] row_addr, // pixel ram row address, 480 (512) lines
    output reg [9:0] col_addr, // pixel ram col address, 640 (1024) pixels
    output reg [11:0] D_out,   // RGB, pixel
    output reg hs,             // horizontal synchronization
    output reg vs              // vertical synchronization
    );

    // h_count: VGA horizontal counter (0-799)
    reg [9:0] h_count; // VGA horizontal counter (0-799): pixels
    always @ (posedge clk) begin
        if (!rst) h_count <= 10'h0;
        else if (h_count == 10'd799) h_count <= 10'h0;
        else h_count <= h_count + 10'h1;
    end

    // v_count: VGA vertical counter (0-524)
    reg [9:0] v_count; // VGA vertical   counter (0-524): lines
    always @ (posedge clk or negedge rst) begin
        if (!rst) v_count <= 10'h0;
        else if (h_count == 10'd799) begin
            if (v_count == 10'd524) v_count <= 10'h0;
            else v_count <= v_count + 10'h1;
        end
    end

    // signals, will be latched for outputs
    wire  [9:0] row    =  v_count - 10'd35;     // pixel ram row addr 
    wire  [9:0] col    =  h_count - 10'd143;    // pixel ram col addr 
    wire        h_sync = (h_count > 10'd95);    //  96 -> 799
    wire        v_sync = (v_count > 10'd1);     //   2 -> 524
    wire        read   = (h_count > 10'd142) && // 143 -> 782
                         (h_count < 10'd783) && //  640 pixels
                         (v_count > 10'd34)  && //  35 -> 514
                         (v_count < 10'd515);   //  480 lines

    // vga signals
    reg rdn; // read pixel RAM (active_low)
    always @ (posedge clk) begin
        row_addr <=  row; // pixel ram row address
        col_addr <=  col;      // pixel ram col address
        rdn      <= ~read;     // read pixel (active low)
        hs       <=  h_sync;   // horizontal synchronization
        vs       <=  v_sync;   // vertical synchronization
        D_out    <=  rdn ? 12'h0 : D_in; // pixel data
    end
endmodule
