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
    input wire isCollisionB1,
    input wire isCollisionB2,
    input wire Pclk // 25MHz pixel clock
    );
    reg [6:0] stack_damage =0;
    
    always @(posedge Pclk)
        begin
            if(isCollisionB1==1)
            begin
                stack_damage = stack_damage + 30;
            end
            
            if(isCollisionB2==1)
            begin
                stack_damage = stack_damage + 30;
            end
            
            if (((xx>50 && xx<200-stack_damage) && (yy>400 && yy<410)))
                begin
                hp_barOn <= 1;
                end
            else
                begin
                hp_barOn <= 0;
                end
        end
 
endmodule
