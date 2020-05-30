`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2020 01:52:43 PM
// Design Name: 
// Module Name: playground
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


module playground(

    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg PlayGroundOn, // 1=on, 0=off
    //output reg [3:0] RED, // 8 bit pixel value from Bee.mem
    //output reg [3:0] GREEN, // 8 bit pixel value from Bee.mem
    //output reg [3:0] BLUE, // 8 bit pixel value from Bee.mem
    input wire Pclk // 25MHz pixel clock
    );
    
    always @(posedge Pclk)
        begin
            if (xx<640 && yy<480)
                begin
                PlayGroundOn <= 1;
                end
         
            else
                begin
                PlayGroundOn <= 0;
                end
        end
endmodule
