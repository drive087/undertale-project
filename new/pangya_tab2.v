`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2020 04:55:31 PM
// Design Name: 
// Module Name: pangya_tab2
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


module pangya_tab2(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg pangyatabOn2, // 1=on, 0=off
//    output reg attack,
    input wire Pclk, // 25MHz pixel clock
    input wire [2:0] state
    );
    
    reg [9:0] delbullet=0;          // counter to slow alien movement
    reg [9:0] B1X = 295;            // Alien1 X start position
    reg [9:0] B1Y = 290;             // Alien1 Y start position
    reg [1:0] Bdir = 1;             // direction of aliens: 0=right, 1=left
    
    always @(posedge Pclk)
        begin
            if (((xx>B1X && xx<B1X+5) && (yy>B1Y && yy<B1Y+30)))
                begin
                pangyatabOn2 <= 1;
                end
            else
                begin
                pangyatabOn2 <= 0;
                end
  
        end
        
//    always @(posedge Pclk)
//        begin
                
//            if(state==3'b100)
//                begin
//                attack<=1;
//                end
//            else
//                begin
//                attack<=0;
//                end
           
//        end
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
                                if (B1X>370)
                                    Bdir<=0;
                            end
                        if (Bdir==0)
                            begin
                                B1X<=B1X-6;
                                if (B1X<220)
                                    Bdir<=1;
                            end
                    end
            end
      end
endmodule
