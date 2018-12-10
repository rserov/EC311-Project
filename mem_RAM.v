`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:08:17 12/09/2018 
// Design Name: 
// Module Name:    mem_RAM 
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
module mem_RAM(
	input clk,
	input reset,
	input signal,
	input [7:0] data_rx,
	output reg [7:0] data_out);
	reg[5:0] w_counter;
	integer i;
	parameter m=0;
	parameter n=0;

// Declare memory 64x8 bits = 512 bits or 64 bytes 
	reg [511:0] memory_ram_d [63:0];
	reg [511:0] memory_ram_q [63:0];

// Use positive edge of clock to read the memory
// Implement cyclic shift right
	always @(posedge clk or negedge reset) begin
    if (!reset) begin
        for (i=0;i<64; i=i+1)
            memory_ram_q[i] <= 0;end
    else begin
        for (i=0;i<64; i=i+1)
             memory_ram_q[i] <= memory_ram_d[i];end
	end
	always @(*) begin
		if (signal) begin
			for (i=0;i<64; i=i+1) begin
				memory_ram_d[i] = memory_ram_q[i];
				if (w_counter <= 63) begin
					memory_ram_d[i] = {memory_ram_d[i],data_rx};
					w_counter <= w_counter + 1'b1; end
				else if (w_counter >63) begin
					memory_ram_d[i+1] = {memory_ram_d[i+1],data_rx};
					w_counter <= w_counter + 1'b1; end
			end
	   end
	end
	always @ (*) begin
	     data_out <= memory_ram_q[m][n+7:n];
	end
endmodule