`timescale 1ns / 1ps

module RAM(reset, clk, in, out, select, ready);

input en;
input clk, select, reset;
input [0:7] in;
output reg [0:7]out;
output reg ready;
parameter size = 8'd10; // size the image
reg[0:7] mem[0:size-1][0:size-1];
reg [0:7] i;
reg [0:7] j;
wire [0:7]tempout;
reg [0:20]sum;
wire [0:7] thresh_val;
reg enable_out;

wire [7:0] dout;
/*always @ (posedge clk) begin

if (j<=size-1) begin
  mem[i][j] = in;
  j <= tempj;
  out <= tempout;
end else begin
  mem[i][j] <= in;
  i <= tempi;
  j <= tempj;
  out <= tempout;
end

end//always

always @ (*)begin
 if (mem[i][j]>8'd50)begin
  memout[i][j] = 8'd255;
 end else begin 
  memout[i][j] = 8'd0;
 end
 end//always 

*/


////for index
//always @ (posedge clk) begin
//if (j<size-1) begin
//  j <= tempj;
//end else begin
//  i <= tempi;
//  j <= tempj;
//end
//end//always

always @(posedge clk) begin
	if (reset)
	begin
		i <= 0;
		j <= 0;
		enable_out <= 0;
	end
	else if (en)
		if ((i == size-1) && (j == size-1))
		begin
			i <= 0; j <= 0;
			enable_out <= 1;
		end
		else if (j < size-1)
		begin
			i <= i;
			j <= j + 1;
			enable_out <= enable_out;
		end
		else if (j == size-1)
		begin
			i <= i+1;
			j <= 0;
			enable_out <= enable_out;
		end
		else 
		begin
			i <= i;
			j <= j;
			enable_out <= enable_out;
		end
	else
	begin 
		i <= i;
		j <= j;
		enable_out <= enable_out;
	end
end



always @ (posedge clk) begin
if (reset) begin
    sum <= 0;
    out <= 0;//threshold
    ready <= 0;
end else if (~enable_out) begin
    mem[i][j] <=in;
    sum <= sum + in;
    out <= 0;//threshold
    ready <= 0;
end else if (select) begin
	sum <= sum;
	out <= tempout;//threshold
  ready <= enable_out;
end else begin
   sum <= sum;
   out <= 0;
	ready <= 0;
end
end//always

//always @ (*) begin
//if (i >= size-1 && j >= size-1)
//  enable_out <= 1'b1;
//end

//always @(*)begin
//  if (reset)begin
//    ready <= 0;
//  end else if (enable_out) begin
//    ready <= clk;
//  end else begin
//    ready <= 0;
//  end
//end//always 
//  



assign dout = mem[i][j];

//assign tempi =(i>=size-1)?8'b0:(i +1'b1);
//assign tempj = (j>=size-1)?8'b0:(j +1'b1);
assign thresh_val = sum/(size*size);
assign tempout = (dout>thresh_val)?8'd255:8'd0;
//assign ready = (i==0 && enable_out)? ~ready:1'b0;

endmodule
