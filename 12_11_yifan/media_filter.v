`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:49:53 12/05/2018 
// Design Name: 
// Module Name:    media_filter 
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
module media_filter(
	input tx_ready, 
	input D, 
	input [7:0]add_1, 
	input [7:0]add_2, 
	input [7:0]add_3, 
	input [7:0]add_4, 
	input [7:0]add_5, 
	input [7:0]add_6, 
	input [7:0]add_7, 
	input [7:0]add_8, 
	input [7:0]add_9,
	output reg [7:0]med_val
    );
	wire D_o;
	D_signal_delay delay(.clk(clk),.D(D),.D_o(D_o));
	reg [7:0] a, b, c, M, d, e, f, N, g, h, i, O;
	always @ (*) begin
		if (tx_ready && D_o) begin
				 a <= add_1-add_2;
				 b <= add_2-add_3;
				 c <= add_1-add_3;
				 d <= add_4-add_5;
				 e <= add_5-add_6;
				 f <= add_4-add_6;
				 g <= add_7-add_8;
				 h <= add_8-add_9;
				 i <= add_7-add_9;end
		else a<=b<=c<=d<=e<=f<=g<=h<=i<=0;end
	always @ (*)begin
		if (tx_ready && D_o) begin
			if (a*b >0) begin
				M <= add_2; end
			else if (a*c >0) begin
				M <= add_3; end 
			else if (d*e >0) begin
				N <= add_5; end
			else if (d*f >0) begin
				N <= add_6; end
			else if (g*h >0) begin
				O <= add_8; end
			else if (g*i >0) begin
				O <= add_9; end
			else begin  M <= add_1; N <= add_4; O <= add_7;end end
		else M<=N<=O<=0;end
	always @ (*) begin
		if (tx_ready && D_o) begin
			if (M*N > 0) begin
				med_val <= N; end
			else if (M*O > 0) begin
					med_val <= O; end
			else begin med_val <= M; end end
		else med_val <= 0;end 
endmodule
