`timescale 1ns / 1ps

module thresh(enable_out,clk,mem,thresh_val,out);

input clk, enable_out;
parameter size = 8'd10;
input [0:8]mem[0:size-1][0:size-1];
input [0:7] thresh_val;
output reg [0:7]out;
reg [0:7] i = 8'b0;
reg [0:7] j= 8'b0;
wire [0:7] tempi, tempj;
wire [0:7]tempout;


always @ (posedge clk) begin
if (~enable_out) begin
  out<= 8'b0;
end else if (j<=size-1) begin
   out <= tempout;
   j <= tempj;
end else begin
  out <= tempout;
  i <= tempi;
  j <= tempj;
end
end//always


assign tempi =(i>=size-1)?8'b0:(i +1'b1);
assign tempj = (j>=size-1)?8'b0:(j +1'b1);
assign tempout = (mem[i][j]>thresh_val)?8'd255:8'd0;


endmodule
