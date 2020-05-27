`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2020 03:01:37 PM
// Design Name: 
// Module Name: collision
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


module collision(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire spriteOn1,
    input wire spriteOn2,
    output reg isCollision, // 1=on, 0=off
    output reg [9:0] check_once,
    input wire Pclk // 25MHz pixel clock
    );
    reg [9:0] check_once  = 0;

    always @ (posedge Pclk)
    begin
        if(spriteOn1 == 1 && spriteOn2 == 1)
        begin
            isCollision = 1;
            check_once = check_once + 1;
        end
        else
        begin
            isCollision = 0;
            check_once = 0;
        end
    end
endmodule
