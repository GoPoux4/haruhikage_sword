`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:37:03 01/15/2024 
// Design Name: 
// Module Name:    Buzzer 
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
module Buzzer(
    input wire clk,
    input wire rst,
    output reg beep
    );

    parameter SPEED = 3;
    parameter COUNTER_6M = 50_000_000 / 6_000_000 / 2 - 1;
    parameter COUNTER_S = 50_000_000 / SPEED / 2 - 1;
    parameter LENGTH = 783;

    reg [23:0] cnt_6m;
    reg clk_6m;
    reg [23:0] cnt_s;
    reg clk_s;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            cnt_6m <= 0;
            clk_6m <= 0;
            cnt_s <= 0;
            clk_s <= 0;
        end else begin
            cnt_6m <= cnt_6m + 1;
            if (cnt_6m == COUNTER_6M) begin
                cnt_6m <= 0;
                clk_6m <= ~clk_6m;
            end
            cnt_s <= cnt_s + 1;
            if (cnt_s == COUNTER_S) begin
                cnt_s <= 0;
                clk_s <= ~clk_s;
            end
        end
    end

    reg [13:0] cnt_beep;
    wire [13:0] note_hz;
    wire note_pause;

    always @(posedge clk_6m or negedge rst) begin
        if (!rst) begin
            cnt_beep <= 0;
            beep <= 0;
        end else begin
            if (cnt_beep == note_hz) begin
                cnt_beep <= 0;
                if (note_pause && clk_s == 0) begin
                    beep <= 0;
                end else begin
                    beep <= ~beep;
                end
            end else begin
                cnt_beep <= cnt_beep + 1;
            end
        end
    end

    reg [9:0] note_idx;

    always @(negedge clk_s or negedge rst) begin
        if (!rst) begin
            note_idx <= 0;
        end else begin
            if (note_idx == LENGTH - 1) begin
                note_idx <= LENGTH - 1;
            end else begin
                note_idx <= note_idx + 1;
            end
        end
    end

    haruhikage haru(.clka(clk), .ena(clk_s), .addra(note_idx), .douta({note_hz, note_pause}));

endmodule
