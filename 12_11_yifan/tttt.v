`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:53:35 12/10/2018
// Design Name:   bram
// Module Name:   X:/Desktop/UART_Matlab_HDL/UART/qqg/tttt.v
// Project Name:  qqg
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tttt;

	// Inputs
	reg clka;
	reg [0:0] wea;
	reg [11:0] addra;
	reg [15:0] dina;
	reg clkb;
	reg enb;
	reg [11:0] addrb;

	// Outputs
	wire [15:0] doutb;

	// Instantiate the Unit Under Test (UUT)
	bram uut (
		.clka(clka), 
		.wea(wea), 
		.addra(addra), 
		.dina(dina), 
		.clkb(clkb), 
		.enb(enb), 
		.addrb(addrb), 
		.doutb(doutb)
	);

	initial begin
		// Initialize Inputs
		clka = 0;
		wea = 0;
		addra = 0;
		dina = 0;
		clkb = 0;
		enb = 0;
		addrb = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

