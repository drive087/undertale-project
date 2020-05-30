`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2020 09:14:20 PM
// Design Name: 
// Module Name: HeartRom
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


module HeartRom(

    input wire [9:0] i_addr, // (9:0) or 2^10 or 1024, need 34 x 27 = 918
    input wire i_clk2,
    output reg [7:0] heart_dataout // (7:0) 8 bit pixel value from Bee.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:224]; // 8 bit values for 918 pixels of Bee (34 x 27)

    initial begin
            $readmemh("heart15.mem", memory_array);
    end

    always @ (posedge i_clk2)
            heart_dataout <= memory_array[i_addr];  
endmodule
