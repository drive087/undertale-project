`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2020 04:08:30 PM
// Design Name: 
// Module Name: MonsterSprite
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


//--------------------------------------------------
// MonsterSprite Module : Digilent Basys 3               
// BeeInvaders Tutorial 4 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//--------------------------------------------------
`timescale 1ns / 1ps

// Setup MonsterSprite Module
module MonsterSprite(
    input wire [9:0] xx,            // current x position
    input wire [9:0] yy,            // current y position
    input wire aactive,             // high during active pixel drawing
    output reg M1SpriteOn,          // 1=on, 0=off
    output wire [7:0] M1dataout,    // 8 bit pixel value from Alien1.mem
    input wire Pclk                 // 25MHz pixel clock
    );

    // instantiate Alien1Rom code
    reg [9:0] M1address;            // 2^10 or 1024, need 31 x 26 = 806
    Monster1Rom Monster1VRom (.i_M1addr(M1address),.i_clk2(Pclk),.o_M1data(M1dataout));


    // setup character positions and sizes
    reg [9:0] M1X = 135;            // Alien1 X start position
    reg [9:0] M1Y = 85;             // Alien1 Y start position
    localparam M1Width = 31;        // Alien1 width in pixels
    localparam M1Height = 26;       // Alien1 height in pixels

    reg [9:0] MoX = 0;              // Offset for X Position of next Alien in row
    reg [9:0] MoY = 0;              // Offset for Y Position of next row of Aliens
    reg [9:0] McounterW = 0;        // Counter to check if Alien width reached
    reg [9:0] McounterH = 0;        // Counter to check if Alien height reached
    reg [3:0] McolCount = 5;       // Number of horizontal aliens in all columns
    reg [1:0] Mdir = 1;             // direction of aliens: 0=right, 1=left
    reg [9:0] delaliens=0;          // counter to slow alien movement

    always @ (posedge Pclk)
    begin
        if (aactive)
            begin
                // check if xx,yy are within the confines of the Alien characters
                // Alien1
                if (xx==A1X+AoX-1 && yy==A1Y+AoY)
                    begin
                        A1address <= 0;
                        A1SpriteOn <=1;
                        AcounterW<=0;
                    end                   
                if ((xx>A1X+AoX-1) && (xx<A1X+A1Width+AoX) && (yy>A1Y+AoY-1) && (yy<A1Y+A1Height+AoY))   
                    begin
                        A1address <= A1address + 5;
                        AcounterW <= AcounterW + 1;
                        A1SpriteOn <=1;
                        if (AcounterW==A1Width-1)
                            begin
                                AcounterW <= 0;
                                AoX <= AoX + 40;
                                if(AoX<(AcolCount-1)*40)
								    A1address <= A1address - (A1Width-1);
							    else
							    if(AoX==(AcolCount-1)*40)
								    AoX<=0;
					        end
                    end
                else
                    A1SpriteOn <=0;
                    
                // Alien2    
                if (xx==A2X+AoX-1 && yy==A2Y+AoY)
                    begin
                        A2address <= 0;
                        A2SpriteOn <=1;
                        AcounterW<=0;
                    end
                if ((xx>A2X+AoX-1) && (xx<A2X+A2Width+AoX) && (yy>A2Y+AoY-1) && (yy<A2Y+AoY+A2Height))
                    begin
                        A2address <= A2address + 1;
                        AcounterW <= AcounterW + 1;
                        A2SpriteOn <=1;
                        if (AcounterW==A2Width-1)
                            begin
                                AcounterW <= 0;
                                AoX <= AoX + 40;
                                if(AoX<(AcolCount-1)*40)
								    A2address <= A2address - (A2Width-1);
							    else
							    if(AoX==(AcolCount-1)*40)
                                    begin
								        AoX<=0;
								        AcounterH <= AcounterH + 1;
								        if(AcounterH==A2Height-1)
                                            begin
							                    AcounterH<=0;
							                    AoY <= AoY + 30;
							                    if(AoY==30)
							                        begin
								                        AoY<=0;
								                        AoX<=0;
				                                    end
						                    end
                                    end
                            end         
                    end
                else
                    A2SpriteOn <=0;
                    
                // Alien3
                if (xx==A3X+AoX-1 && yy==A3Y+AoY)
                    begin
                        A3address <= 0;
                        A3SpriteOn <=1;
                        AcounterW<=0;
                        AcounterH<=0;
                    end
                if ((xx>A3X+AoX-1) && (xx<A3X+AoX+A3Width) && (yy>A3Y+AoY-1) && (yy<A3Y+AoY+A3Height))
                    begin
                        A3address <= A3address + 1;
                        AcounterW <= AcounterW + 1;
                        A3SpriteOn <=1;
                        if (AcounterW==A3Width-1)
                            begin
                                AcounterW <= 0;
                                AoX <= AoX + 40;
                                if(AoX<(AcolCount-1)*40)
								    A3address <= A3address - (A3Width-1);
							    else
							    if(AoX==(AcolCount-1)*40)
                                    begin
								        AoX<=0;
								        AcounterH <= AcounterH + 1;
								        if(AcounterH==A3Height-1)
                                            begin
							                    AcounterH<=0;
							                    AoY <= AoY + 36;
							                    if(AoY==36)
							                        begin
								                        AoY<=0;
								                        AoX<=0;
				                                    end
						                    end
								    end	    
					        end
                    end
                else
                    A3SpriteOn <=0;            
            end
    end
    
    always @ (posedge Pclk)
    begin
        // slow down the alien movement / move aliens left or right
        if (xx==639 && yy==479)
            begin
                delaliens<=delaliens+1;
                if (delaliens>1)
                    begin
                        delaliens<=0;
                        if (Adir==1)
                            begin
                                A1X<=A1X-10;
                                A2X<=A2X-10;
                                A3X<=A3X-10;
                                A1Y<=A1Y+10;
                                A2Y<=A2Y+10;
                                A3Y<=A3Y+10;
                                if (A1X<23)
                                    Adir<=0;
                            end
                        if (Adir==0)
                            begin
                                A1X<=A1X+10;
                                A2X<=A2X+10;
                                A3X<=A3X+10;
                                A1Y<=A1Y-10;
                                A2Y<=A2Y-10;
                                A3Y<=A3Y-10;
                                if (A1X+A1Width+((AcolCount-1)*40)>636)    
                                    Adir<=1;
                            end
                    end
            end
    end
endmodule
