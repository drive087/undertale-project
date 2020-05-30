`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2020 03:08:38 PM
// Design Name: 
// Module Name: timer_state
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


module timer_state(
    input wire i_clk,      // 100MHz onboard clock
    input wire attack,
    input wire character_alive,
    input wire monster_alive,
    input wire [2:0] state,
    output reg [1:0] o_state_game      // 25MHz pixel clock
    );
    
    reg [26:0] counter =0;    
    reg [1:0] o_state_game = 2; 
    
    always @ (posedge i_clk)
        begin
        
            if(character_alive == 0 || monster_alive == 0)
            begin
                o_state_game = 2;
            end
            
            if(o_state_game ==2 && state == 3'b100)
            begin
               o_state_game = 0;
            end
            else
            if(o_state_game == 0 && counter < 125000500)
            begin
                counter = counter +1;
            end
            else
            if(counter > 125000000 && o_state_game == 0)
                begin
                o_state_game = 1;
                end
            else
            if(attack==1 && o_state_game == 1)
                begin
                counter = 0;
                o_state_game = 0;
                end
            
        end
endmodule
