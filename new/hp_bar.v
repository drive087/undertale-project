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
    output reg character_alive,
    input wire isCollisionB1,
    input wire isCollisionB2,
    input wire isCollisionGB,
    input wire isCollisionBig,
    input wire [1:0] state_game,
    input wire Pclk // 25MHz pixel clock
    );
    reg [9:0] stack_damage =0;
    reg character_alive = 1;
    reg check_onceB1 = 0;
    reg check_onceB2 = 0;
    reg check_onceGB = 0;
    reg check_onceBig = 0;
    reg [9:0] heal =0;
    
    always @(posedge Pclk)
        begin
            if(isCollisionB1==1 && check_onceB1 == 0)
            begin
                stack_damage = stack_damage + 30;
                check_onceB1 = 1;
            end
            
            if(isCollisionB2==1 && check_onceB2 == 0)
            begin
                stack_damage = stack_damage + 30;
                check_onceB2 = 1;
            end
            
            if(isCollisionBig==1 && check_onceBig == 0)
            begin
                stack_damage = stack_damage + 60;
                check_onceBig = 1;
            end
            
            if(isCollisionGB==1 && check_onceGB == 0)
            begin
                heal = 60;
                check_onceGB = 1;
            end
            
            if(state_game ==1)
            begin
                check_onceB1 = 0;
                check_onceB2 = 0;
                check_onceBig = 0;
            end
            
            if (((xx>50 && xx<200-stack_damage+heal) && (yy>400 && yy<410)))
                begin
                hp_barOn <= 1;
                end
            else
                begin
                hp_barOn <= 0;
                end
        end
    always @(posedge Pclk)
    begin
    if(stack_damage >= 150+heal)
                begin
                    character_alive =0;
                end
    else
    begin
        character_alive =1;
    end

    end
 
endmodule
