`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2020 11:17:31 PM
// Design Name: 
// Module Name: ObstacleSprite
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


module ObstacleSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg ObstacleSpriteOn, // 1=on, 0=off
    input wire isCollisionBig,
    input wire Pclk // 25MHz pixel clock
    );
    
    reg [9:0] delbullet=0;          // counter to slow alien movement
    reg [9:0] B1X = 320;            // Alien1 X start position
    reg [9:0] B1Y = 320;             // Alien1 Y start position
    reg [1:0] Bdir = 1;             // direction of aliens: 0=right, 1=left


    
    always @(posedge Pclk)
        begin
            if(isCollisionBig == 1)
            begin
                ObstacleSpriteOn <= 0;
            end
            else
            if (((xx-B1X)**2 + (yy-B1Y)**2) <= 81)
                begin
                ObstacleSpriteOn <= 1;
                end
            else
                begin
                ObstacleSpriteOn <= 0;
                end
        end
    
        
    always @ (posedge Pclk)
        begin
        // slow down the alien movement / move aliens left or right
        if (xx==639 && yy==479)
            begin
                delbullet<=delbullet+1;
                if (delbullet>1)
                    begin
                        delbullet<=0;
                        if (Bdir==1)
                            begin
                                B1Y<=B1Y+6;
                                if (B1Y>375)
                                    Bdir<=0;
                            end
                        if (Bdir==0)
                            begin
                                B1Y<=B1Y-6;
                                if (B1Y<220)
                                    Bdir<=1;
                            end
                    end
            end
      end
endmodule
