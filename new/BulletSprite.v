`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2020 09:33:35 PM
// Design Name: 
// Module Name: BulletSprite
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


module BulletSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg BulletSpriteOn, // 1=on, 0=off
    //output reg [3:0] RED, // 8 bit pixel value from Bee.mem
    //output reg [3:0] GREEN, // 8 bit pixel value from Bee.mem
    //output reg [3:0] BLUE, // 8 bit pixel value from Bee.mem
    input wire isCollisionB1,
    input wire Pclk // 25MHz pixel clock

    );
    
    reg [9:0] delbullet=0;          // counter to slow alien movement
    reg [9:0] B1X = 226;            // Alien1 X start position
    reg [9:0] B1Y = 222;             // Alien1 Y start position
    reg [1:0] Bdir = 1;             // direction of aliens: 0=right, 1=left


    
    always @(posedge Pclk)
        begin
            if(isCollisionB1 == 1)
            begin
                BulletSpriteOn <= 0;
            end
            else
            if (((xx-B1X)**2 + (yy-B1Y)**2) <= 25)
                begin
                BulletSpriteOn <= 1;
                end
            else
                begin
                BulletSpriteOn <= 0;
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
                                B1X<=B1X+6;
                                if (B1X>410)
                                    Bdir<=0;
                            end
                        if (Bdir==0)
                            begin
                                B1X<=B1X-6;
                                if (B1X<230)
                                    Bdir<=1;
                            end
                    end
            end
      end
      
//    always @ (posedge Pclk)
//        begin
//        // slow down the alien movement / move aliens left or right
//        if (xx==B1X && yy==B1Y)
//            BulletSpriteOn <=1;
//        end
endmodule
