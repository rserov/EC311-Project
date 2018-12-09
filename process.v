`timescale 1ns / 1ps

module process(
	input clk,
	input reset,
	input valid_rx,
	input [7:0] data_rx,
	input ready_tx,
	input select,
	output [7:0] data_out,
	output data_valid,
	output reg [1:0] state
    );
	 
	 parameter size = 8'd4;//size image
	 reg [7:0] mem [0:size*size-1]; //memory  
	 
	 reg [31:0] i; //writing index 
	 reg [31:0] j; //reading index
	 reg j_tmp; //fixing output problem
	 integer k;
	 
	 reg wr_done;
	 reg rd_done;
	 
	 reg data_valid_r;
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


	parameter WAIT_FOR_START = 2'b00;
	parameter WRITE_DATA = 2'b01;
	parameter READ_DATA = 2'b10;
	parameter DONE = 2'b11;



	always@(posedge clk) begin
		if(reset) begin
			i <= 0;
			sum <= 0;
			j <= 0;
			data_out_r <= 0;
			data_median_r <=0;
			data_valid_r <= 1'b0;	
			state <= 2'b00;
			for (k=0; k < size*size; k=k+1) begin
            mem[k] <= 8'b0; //reset array
        end
		end else
		case (state)
			WAIT_FOR_START: begin
				j <= 0;
				j_tmp <= 0;
				data_out_r <= 0;
				data_median_r <= 0;
				data_valid_r <= 1'b0;
				if(valid_rx) begin
					mem[i] <= data_rx;
					i <= i + 1'b1;
					sum <= sum + data_rx;
					state <= WRITE_DATA;
				end else begin
					i <= 0;
					sum <= sum;
					state <= WAIT_FOR_START;
				end
			end
			
			WRITE_DATA: begin
				j <= 0;
				j_tmp <= 0;
				data_out_r <= 0;
				data_median_r <= 0;
				data_valid_r <= 1'b0;
				if(valid_rx) begin
					mem[i] <= data_rx;
					i <= i + 1'b1;
					sum <= sum + data_rx;
				end else begin
					i <= i;
					sum <= sum;
				end
				if(i <= size*size-1)
					state <= WRITE_DATA;
				else
					state <= READ_DATA;
			end	
			
			READ_DATA: begin
				i <= 0;
				sum <= sum;
				if(ready_tx) begin
				   data_median_r <= data_median;
					data_out_r <= (mem[j]>=thresh_val)?8'd255:8'd0;//calcualte and output value
					data_valid_r <= 1'b1;
					j_tmp <= j_tmp + 1'b1;
				   if(j_tmp == 1)
					  j <= j + 1'b1;
					else
						j <= j;
				end else begin
					data_out_r <= 0;
					data_median_r <= 0;
					data_valid_r <= 1'b0;
					j_tmp <= j_tmp;
					j <= j;
				end
				if(j <= size*size-1)
					state <= READ_DATA;
				else
					state <= DONE;
			end
					
			DONE: begin
				i <= 0;
				j <= 0;
				j_tmp <= 0;
				sum <= 0;
				data_out_r <= 0;
				data_median_r <= 0;
				data_valid_r <= 1'b0;
				state <= WAIT_FOR_START;
			end
		endcase
	end//always


   always @(*) begin
		if (j<=size-1) begin // first and last line
			data_median <= mem[j];
		end else if (j>=size*(size-1)) begin
			data_median <= mem[j];
		end else if (j%size == 0) begin
			data_median <= mem [j];
		end else if ( j%size == size-1 ) begin // left and right
			data_median <= mem [j];
		end else if (j<size*size) begin // every other cases 
			data_median <= sort_median;
		end 
   end //always
	
	always @(*) begin
		if (j>=size+1 && j<=size*(size-1)-2) begin
			w0 <= mem [j-size-1];
			w1 <= mem [j-size];
			w2 <= mem [j-size+1];
			w3 <= mem[j-1];
			w4 <= mem[j];
			w5 <= mem[j+1];
			w6 <= mem[j+size-1];
			w7 <= mem[j+size];
			w8 <= mem[j+size+1];
		end 
	end//always 
	
	
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
		.median(sort_median)
	);


assign thresh_val = sum/(size*size);
assign data_out =  (select==0)?data_out_r:data_median_r;
assign data_valid = data_valid_r;

endmodule
