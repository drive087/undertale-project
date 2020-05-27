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
    output reg o_state_game      // 25MHz pixel clock
    );
    
    reg [26:0] counter =0;    
    reg [1:0] o_state_game = 0; 
    
    always @ (posedge i_clk)
        begin
            counter = counter +1;
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
