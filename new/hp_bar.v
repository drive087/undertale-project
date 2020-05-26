`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2020 09:20:30 PM
// Design Name: 
// Module Name: hp_bar
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


module hp_bar(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    //input wire damage,
    output reg hp_barOn, // 1=on, 0=off
    input wire Pclk // 25MHz pixel clock
    );
    
    
    always @(posedge Pclk)
        begin
            if (((xx>50 && xx<150) && (yy>400 && yy<410)))
                begin
                hp_barOn <= 1;
                end
        end
endmodule
