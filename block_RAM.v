`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:08:31 12/08/2018 
// Design Name: 
// Module Name:    block_RAM 
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
module block_RAM(clk, addr, read_write, clear, data_in, data_out);
  parameter n = 2; //the reg_array will have 4 addresses to write to
  parameter w = 8; //each address will be 8 bits long 
  
  input clk, read_write, clear; 
  input [n-1:0] addr; 
  input [w-1:0] data_in; 
  output reg [w-1:0] data_out; 
  
  reg [w-1:0]reg_array[2**n-1:0]; 
  

  integer i; 

  initial begin
    for(i = 0; i < 2**n; i = i + 1)begin 
      reg_array[i] <= 0; 
    end 
  end 

  always @(posedge clk)begin 
    if(read_write == 1)begin 
      reg_array[addr] <= data_in; 	//Must input what the address should be a play around with timing in the testbench
                                    //If we want to have each address have 64 pixels, we need a bit counter to count the amount of bits per row 
    end 
    //if(clear == 1)begin
		//for(i = 0; i < 2**n; i = i + 1)begin
		  //reg_array[i] <= 0;
		//end 
    //end
    data_out = reg_array[addr]; 	 
  end 
  
endmodule
