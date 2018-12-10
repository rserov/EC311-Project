`timescale 1ns / 1ps

module processing(
	 input [7:0]data_in,
	 input switch, clk, reset,
	 output reg [7:0]data_out);
	 
	 reg [31:0] i; //writing index 
	 reg [31:0] j; //reading index
	 reg [511:0] memory_ram_q [63:0];
	 reg j_tmp; //fixing output problem
	 reg signal;
	 reg [7:0] data_out_r;//threshhold data
	 reg [7:0] data_median_r;
	 reg [7:0] data_median;
	 wire [7:0] sort_median;
    reg [31:0] sum;
	 wire [31:0] thresh_val;

	 
	reg [7:0] w0; //window elements
	reg [7:0] w1;
	reg [7:0] w2;
	reg [7:0] w3;
	reg [7:0] w4;
	reg [7:0] w5;	
	reg [7:0] w6;
	reg [7:0] w7;
	reg [7:0] w8;
	parameter size=64;
always @(posedge clk or negedge reset) begin
case(switch)
	0:begin
		if (data_in <=128) begin
			data_out <= 0; end
		else begin
			data_out <= 1; end
	end
	1: begin
			if (j<=512-8) begin // first and last line
				data_median <= data_in;
			end else if (j>=size*(512-8)) begin
				data_median <= data_in;
			end else if (j% size == 0) begin
				data_median <= data_in;
			end else if ( j%size == size-1 ) begin // left and right
				data_median <= data_in;
			end else if (j<size*size) begin // every other cases //need work on converting to the new bits version
			//data_median <= sort_median;
				data_median <= 0;
			end 
	
//		always @(*) begin
			if (j>=size+1 && j<=size*(size-1)-2) begin
				w0 <= mem [j-size-1];
				w1 <= mem [j-size];
				w2 <= mem [j-size+1];
				w3 <= mem [j-1];
				w4 <= mem [j];
				w5 <= mem [j+1];
				w6 <= mem [j+size-1];
				w7 <= mem [j+size];
				w8 <= mem[j+size+1];
			end 
//		end//always 
			 sort_median sort (
		.clk(clk), 
		.reset(reset), 
		.i1(w0), 
		.i2(w1), 
		.i3(w2), 
		.i4(w3), 
		.i5(w4), 
		.i6(w5), 
		.i7(w6), 
		.i8(w7), 
		.i9(w8), 
		.median(sort_median));
		end
	endcase
end 
endmodule
