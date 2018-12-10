`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:15:02 12/09/2018 
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
    clk,
    reset,
    write_data,
    read_data
);
input           clk;
input           reset;
input[7:0]      write_data;
output[511:0]     read_data;
reg[5:0]       w_counter;
reg[511:0]     read_data, w_data;

integer out, i;

// Declare memory 64x8 bits = 512 bits or 64 bytes 
reg [511:0] memory_ram_d [63:0];
reg [511:0] memory_ram_q [63:0];

// Use positive edge of clock to read the memory
// Implement cyclic shift right
always @(posedge clk or negedge reset)
begin
    if (!reset)
    begin
        for (i=0;i<64; i=i+1)
            memory_ram_q[i] <= 0;
    end
    else
    begin
        for (i=0;i<64; i=i+1)
             memory_ram_q[i] <= memory_ram_d[i];
    end
end
always @(*)
begin
    for (i=0;i<64; i=i+1) begin
        memory_ram_d[i] = memory_ram_q[i];
			if (w_counter <= 63)
				memory_ram_d[i] = {memory_ram_d[i],write_data};
			else if (w_counter >63)
				memory_ram_d[i+1] = {memory_ram_d[i+1],write_data};
		end
end
endmodule 