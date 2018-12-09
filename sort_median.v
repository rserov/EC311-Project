`timescale 1ns / 1ps



module sort_median(clk, reset, i1, i2, i3, i4, i5, i6, i7, i8, i9, median);

  parameter pix = 9; //Number of inputs
  parameter n = 8; //Size of the register

  input clk, reset;
  input [n-1:0] i1, i2, i3, i4, i5, i6, i7, i8, i9;
  output reg[7:0] median;


  
  integer i, j;
  reg [n-1:0] temp;
  reg [n-1:0] array [0:8];
  
  always @(negedge clk) begin 	
   if (reset) begin
	 array[0] = 0;
	 array[1] = 0;
	 array[2] = 0;
	 array[3] = 0;
	 array[4] = 0;
	 array[5] = 0;
	 array[6] = 0;
	 array[7] = 0;
	 array[8] = 0;
	end else begin 
    array[0] = i1;
	 array[1] = i2;
	 array[2] = i3;
	 array[3] = i4;
	 array[4] = i5;
	 array[5] = i6;
	 array[6] = i7;
	 array[7] = i8;
	 array[8] = i9;
	 
   for (i = pix-1; i > 0; i = i - 1) begin
            for (j = 0 ; j < i; j = j + 1) begin
                if (array[j] < array[j + 1]) begin
                    temp = array[j];
                    array[j] = array[j + 1];
                    array[j + 1] = temp;
                end 
            end
        end
  median = array[4]; 
  end
end //always
  

  
endmodule
