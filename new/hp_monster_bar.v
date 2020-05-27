`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2020 12:47:00 PM
// Design Name: 
// Module Name: hp_monster_bar
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


module hp_monster_bar(
    
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    input wire [6:0] pangya_damage,
    //input wire damage,
    output reg hp_monster_barOn, // 1=on, 0=off
    input wire attack,
    input wire Pclk // 25MHz pixel clock
    );
    reg [9:0] stack_damage  = 0;
    
    always @(posedge Pclk)
        begin
            if(attack == 1)
            begin
            
            stack_damage = stack_damage+pangya_damage;
            end
            
            if (((xx>50 && xx<200-stack_damage) && (yy>420 && yy<430)))
                begin
                hp_monster_barOn <= 1;
                end
            else
                begin
                hp_monster_barOn <= 0;
                end
        end
endmodule
