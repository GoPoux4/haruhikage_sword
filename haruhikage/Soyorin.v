`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:30:00 01/15/2024 
// Design Name: 
// Module Name:    Soyorin 
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
module Soyorin(
    input wire clk,
    input wire rst,
    output wire [11:0] D_out,   // RGB, pixel
    output wire hs,             // horizontal synchronization
    output wire vs              // vertical synchronization
    );

    parameter WIDTH = 640;
    parameter HEIGHT = 480;

    wire [31:0] clkdiv;
    wire [9:0] row_addr;
    wire [9:0] col_addr;
    wire [11:0] vga_data;

    clkdiv c0(.clk(clk), .rst(rst), .clkdiv(clkdiv));

    soyorin soyo0(.clka(clk), .ena(1'b1), .addra(row_addr * WIDTH + col_addr), .douta(vga_data));

    VGAdriver vga0(.clk(clkdiv[1]), .rst(rst), .D_in(vga_data), .row_addr(row_addr),
                  .col_addr(col_addr), .D_out(D_out), .hs(hs), .vs(vs));

endmodule
