`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2020 02:02:15 PM
// Design Name: 
// Module Name: character
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


module character(

    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg characterOn, // 1=on, 0=off
    output wire [7:0] character_dataout, 
    input wire Pclk // 25MHz pixel clock
    );
    
    reg [9:0] address; // 2^10 or 1024, need 34 x 27 = 918
    BeeRom BeeVRom (.i_addr(address),.i_clk2(Pclk),.o_data(character_dataout));
            
    // setup character positions and sizes
    reg [9:0] CharacterX = 300; // Bee X start position
    reg [8:0] CharacterY = 150; // Bee Y start position
    localparam CharacterWidth = 34; // Bee width in pixels
    localparam CharacterHeight = 27; // Bee height in pixels
    
    always @ (posedge Pclk)
    begin
    if (aactive)
            begin // check if xx,yy are within the confines of the Bee character
                if (xx==CharacterX-1 && yy==CharacterY)
                    begin
                        address <= 0;
                        characterOn <=1;
                    end
                if ((xx>CharacterX-1) && (xx<CharacterX+CharacterWidth) && (yy>CharacterY-1) && (yy<CharacterY+CharacterHeight))
                    begin
                        address <= address + 1;
                        characterOn <=1;
                    end
                else
                    characterOn <=0;
               end
      
    end
    
endmodule
