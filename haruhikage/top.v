`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:27:43 01/15/2024 
// Design Name: 
// Module Name:    top 
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
module top(
    input wire clk,
    input wire rst,
    input wire [15:0] SW,
    output [3:0] r,            // VGA 输出颜色 Red
    output [3:0] g,            // VGA 输出颜色 Green
    output [3:0] b,            // VGA 输出颜色 Blue
    output wire hs,             // horizontal synchronization
    output wire vs,              // vertical synchronization
    output wire beep            // buzzer
    );

    Buzzer b0(.clk(clk), .rst(SW[0]), .beep(beep));

    Soyorin s0(.clk(clk), .rst(rst), .D_out({r, g, b}), .hs(hs), .vs(vs));

endmodule
