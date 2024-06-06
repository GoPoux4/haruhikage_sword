`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:36:21 11/01/2023 
// Design Name: 
// Module Name:    clkdiv 
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
module clkdiv(
    input clk,
    input rst,
    output reg [31:0] clkdiv
    );

    initial clkdiv = 0;

    always @ (posedge clk) begin
        if (!rst) clkdiv <= 0;
        else clkdiv <= clkdiv + 1'b1;
    end

endmodule