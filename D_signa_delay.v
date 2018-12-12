`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:42:30 12/11/2018 
// Design Name: 
// Module Name:    D_signal_delay 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module D_signal_delay(clk,D,D_o);
input clk;
input wire D;
output reg D_o;

reg[1:0] bits;

always @ (posedge clk)
	begin
    D_o <= bits[1];
    bits <= {bits[0], D};
	end

endmodule 