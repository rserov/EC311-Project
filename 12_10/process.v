`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:07:28 12/07/2018 
// Design Name: 
// Module Name:    process 
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
module process(
	input clk,
	input reset,
	input valid_rx,
	input [7:0] data_rx,
	input ready_tx,
	//input select,
	output [7:0] data_out,
	output data_valid,
	output reg [1:0] state
    );
	 
	 parameter size = 64;
	 //reg [7:0] mem [0:size*size-1];
	  
	 reg [31:0] i;
	 reg [31:0] j;
	 reg wr_done;
	 reg rd_done;
	 
	 reg data_valid_r;
	 reg [7:0] data_out_r;
	 
    reg [31:0] sum;
	 wire [31:0] thresh_val;
	 integer a;
/*	 
	 genvar gen_i;
	 generate
		for(gen_i = 0; gen_i < size*size; gen_i = gen_i + 1'b1) begin:init_mem
		always@(posedge clk)
			begin
			if(rst)
				begin
				mem[gen_i] <= 0;
				end
			else if(i == gen_i)
				begin
				mem[gen_i] <= data_rx;
				end
			end
	 endgenerate
*/	 


	parameter WAIT_FOR_START = 2'b00;
	parameter WRITE_DATA = 2'b01;
	parameter READ_DATA = 2'b10;
	parameter DONE = 2'b11;

//	reg [1:0] state;
   reg prev_wr_done;

	reg r_en;
	
	bram uut (
		.clka(clk), 
		.wea(valid_rx), 
		.addra(i[11:0]), 
		.dina(data_rx), 
		.clkb(clk), 
      .enb(r_en),		
		.addrb(j[11:0]), 
		.doutb(data_out)
	);
	
	always@(posedge clk)
	begin
		if(reset)
		begin
			i <= 0;
		end
		else if (valid_rx)
		begin
			i <= i + 1;
		end
		else begin
			i <= i;
		end
	end
	
	
	always @(posedge clk)
	begin 
		if(reset)
		begin
			wr_done <= 0;
		end
		else if (i >= size*size)
		begin
			wr_done <= 1;
		end
		else begin
			wr_done <= 0;
		end
	end
	
	reg flag;
	
	always@(posedge clk)
	begin
		//prev_wr_done <= wr_done;
		if (reset) begin
			j <= 0;
			r_en <= 0;
			flag <= 0;
		end
		else if ((ready_tx == 1) && (i > j) && (wr_done == 1)) 
		begin  //**
			if(flag == 0) begin
			j <= 0;
			r_en <= 1;
			flag <= 1;
			end
			else begin
			flag <= flag;
			j <= j + 1;
			r_en <= 1;
			end
	   end  //**
		else begin	//**	
			j <= j;
			r_en <= 0;
		end  //**
	end //always
	////////////////////////////////////////////////////////////above is receiver, blockram, address generator of IT
	always @(posedge clk)
	begin
		if (reset)
			data_valid_r <= 0;
		else
			data_valid_r <= r_en;
	end

//	reg j_tmp;
//
//	always@(posedge clk)
//		begin
//		if(reset)
//			begin
//			i <= 0;
//			sum <= 0;
//			j <= 0;
//			data_out_r <= 0;
//			data_valid_r <= 1'b0;
//			
//			state <= 2'b00;
//			end
//		else
//			case (state)
//				WAIT_FOR_START:
//					begin
//					j <= 0;
//					j_tmp <= 0;
//					data_out_r <= 0;
//					data_valid_r <= 1'b0;
//					if(valid_rx)
//						begin
//						w_d <= data_rx;
//						i <= i + 1'b1;
//						sum <= sum + data_rx;
//						state <= WRITE_DATA;
//						end
//					else
//						begin
//						i <= 0;
//						sum <= sum;
//						state <= WAIT_FOR_START;
//						end
//					end
//				WRITE_DATA:
//					begin
//					j <= 0;
//					j_tmp <= 0;
//					data_out_r <= 0;
//					data_valid_r <= 1'b0;
//					if(valid_rx)
//						begin
//						w_d <= data_rx;
//						i <= i + 1'b1;
//						sum <= sum + data_rx;
//						end
//					else
//						begin
//						i <= i;
//						sum <= sum;
//						end
//					
//					if(i < size*size)
//						state <= WRITE_DATA;
//					else
//						state <= READ_DATA;
//					end
//					
//				READ_DATA:
//					begin
//					i <= 0;
//					sum <= sum;
//					if(ready_tx)
//						begin
//						data_out_r <= mem[j];
//						data_valid_r <= 1'b1;
//						j_tmp <= j_tmp + 1'b1;
//						if(j_tmp == 1)
//							j <= j + 1'b1;
//						else
//							j <= j;
//						end
//					else
//						begin
//						data_out_r <= 0;
//						data_valid_r <= 1'b0;
//						j_tmp <= j_tmp;
//						j <= j;
//						end
//						
//					if(j < size*size)
//						state <= READ_DATA;
//					else
//						state <= DONE;
//					end
//					
//				DONE:
//					begin
//					i <= 0;
//					j <= 0;
//					j_tmp <= 0;
//					sum <= 0;
//					data_out_r <= 0;
//					data_valid_r <= 1'b0;
//					
//					state <= WAIT_FOR_START;
//					end
//			
//			endcase
//		
//		end
/*
	 always @(posedge clk) begin
		if (reset) begin
//			for (a = 0; a < size*size; a = a+1)
//			begin
//				mem[a] <= 0;
//			end
			i <= 0;
			sum <= 0;
			wr_done <= 0;
		end
		else if ((valid_rx ==1) && (i == size*size-1) && (wr_done == 0)) begin
			i <= 0;
			mem[i] <= data_rx;
			sum <= sum + data_rx;
			wr_done <= 1;
		end
		else if ((valid_rx == 1)  && (wr_done == 0)) begin
			mem[i] <= data_rx;
			i <= i + 1;
			sum <= sum + data_rx;
			wr_done <= wr_done;
		end
		else begin
			i <= i;
			sum <= sum;
			wr_done <= wr_done;
		end
	 end
*/	 
	 assign thresh_val = sum/(size*size);
/*	 
	 always @(posedge clk) begin
	 if (reset) begin
		j <= 0;
		rd_done <= 0;
		data_valid_r <= 0;
		data_out_r <= 0;
	 end
	 else if ((j == size*size-1) && (wr_done == 1) && (ready_tx == 1) && (rd_done == 0))begin
	   j <= 0;
		//data_out_r <= (mem[j]>thresh_val)? 255:0;
		data_out_r <= mem[j];
		data_valid_r <= 1;
		rd_done <= 1;
	 end
	 else if ((ready_tx == 1) && (wr_done == 1) && (rd_done == 0)) begin
		data_valid_r <= 1;
		//data_out_r <= (mem[j] > thresh_val)? 255 : 0;
		data_out_r <= mem[j];
		j <= j + 1;
		rd_done <= rd_done;
	 end
	 else begin
		data_out_r <= data_out_r;
		data_valid_r <= 0;
		j <= j;
	   rd_done <= rd_done;
	 end
	 end
*/
//assign data_out = data_out_r;
assign data_valid = data_valid_r;

endmodule
