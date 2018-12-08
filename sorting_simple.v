module median_sorting(clk, reset, i1, i2, i3, i4, i5, i6, i7, i8, i9, o1, o2, o3, o4, o5, o6, o7, o8, o9);

    parameter pix = 9; //Number of inputs
    parameter n = 8; //Size of the register

  input clk, reset;
  input [n-1:0] i1, i2, i3, i4, i5, i6, i7, i8, i9;
  output reg [n-1:0] o1, o2, o3, o4, o5, o6, o7, o8, o9;

  reg [n-1:0] reg_data1, reg_data2, reg_data3, reg_data4, reg_data5, reg_data6, reg_data7, reg_data8, reg_data9;
  
  always @(posedge clk) begin
    reg_data1 <= i1;
	 reg_data2 <= i2;
	 reg_data3 <= i3;
	 reg_data4 <= i4;
	 reg_data5 <= i5;
	 reg_data6 <= i6;
	 reg_data7 <= i7;
	 reg_data8 <= i8;
	 reg_data9 <= i9;
  end
  
  integer i, j;
  reg [n-1:0] temp;
  reg [n-1:0] array [1:9];
  
  always @(*) begin
    array[1] = reg_data1;
	 array[2] = reg_data2;
	 array[3] = reg_data3;
	 array[4] = reg_data4;
	 array[5] = reg_data5;
	 array[6] = reg_data6;
	 array[7] = reg_data7;
	 array[8] = reg_data8;
	 array[9] = reg_data9;
	 
  for (i = pix; i > 0; i = i - 1) begin
            for (j = 1 ; j < i; j = j + 1) begin
                if (array[j] < array[j + 1]) begin
                    temp = array[j];
                    array[j] = array[j + 1];
                    array[j + 1] = temp;
                end 
            end
        end
  end
  always @(posedge clk) begin
    o1 <= array[1];
	 o2 <= array[2];
	 o3 <= array[3];
	 o4 <= array[4];
	 o5 <= array[5];
	 o6 <= array[6];
	 o7 <= array[7];
	 o8 <= array[8];
	 o9 <= array[9];
  end
endmodule
