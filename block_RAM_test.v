`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:25:36 12/08/2018
// Design Name:   block_RAM
// Module Name:   X:/My Documents/EC311 Labs/imageProcessingProject/block_RAM_test.v
// Project Name:  imageProcessingProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: block_RAM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module block_RAM_test;

	// Inputs
	reg clk;
	reg [2:0] addr;
	reg read_write;
	reg clear;
	reg [7:0] data_in;

	// Outputs
	wire [7:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	block_RAM uut (
		.clk(clk), 
		.addr(addr), 
		.read_write(read_write), 
		.clear(clear), 
		.data_in(data_in), 
		.data_out(data_out)
	);
	
	always #5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		addr = 0;
		read_write = 0;
		clear = 0;
		data_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
	   read_write = 1; 
		
		#5 data_in = 8'b10000001; 
		#4 addr = 1; 
      #5 data_in = 8'b11110000; 
      #4 addr = 2; 
      #5 data_in = 8'b00001111;
		#4 addr = 3;
      #5 data_in = 8'b11111111; 		
          	
	end
      
endmodule

