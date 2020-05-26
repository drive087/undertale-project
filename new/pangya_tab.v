`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2020 03:58:05 PM
// Design Name: 
// Module Name: pangya_tab
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pangya_tab(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg pangyatabOn, // 1=on, 0=off
    output reg [11:0] pangyatab_color, 
    input wire Pclk // 25MHz pixel clock
    );
    
    always @(posedge Pclk)
        begin
            if (((xx>290 && xx<310) && (yy>300 && yy<306)))
                begin
                pangyatabOn <= 1;
                pangyatab_color <= 12'b000011110000;
                end
            else
            if (((xx<340 && xx>309) && (yy>300 && yy<306))||((xx<291 && xx>260) && (yy>300 && yy<306)))
                begin
                pangyatabOn <= 1;
                pangyatab_color <= 12'b110111110000;
                end
            else
            if (((xx<380 && xx>339) && (yy>300 && yy<306))||((xx<261 && xx>220) && (yy>300 && yy<306)))
                begin
                pangyatabOn <= 1;
                pangyatab_color <= 12'b111000100000;
                end
            else
                begin
                pangyatabOn <= 0;
                pangyatab_color <= 12'b000000000000;
                end
        end
endmodule
