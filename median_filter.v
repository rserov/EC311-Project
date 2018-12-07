module median_sorting(clk, reset, d_en, data_in, data_out);
    parameter n = 9; //Number of inputs
    parameter s = 8; //Size of the register

input clk, reset;
input [s-1:0] data_in;
input d_en;
output reg [71:0] data_out;

reg [s-1:0] reg_in [n-1 :0]; //Input registers
reg [s-1:0] reg_out [n-1:0]; // Output registers

reg [7:0] addr_in; //Input register data pointer
reg [7:0] addr_out; // Output register data pointer

reg d_sort;

reg [5:0]sort_count;

integer i,j;

   always @ (posedge clk) begin
     if(reset) begin
       for(i=0; i<n; i=i+1)
         reg_out[i] <= 8'd0;
         addr_in <= 8'd0;
         addr_out <= 8'd0;
         data_out <= 8'd0;
         d_sort <= 1'b0;
         sort_count <= 8'd0;
       end
       else if (!d_en)begin
         reg_in[addr_in] <= data_in;
         addr_in <= addr_in + 1'b1;
         addr_out <= 8'd0;
       end
       else if (!d_en)begin
         
			for (j=n-1; j>=1; j=j-1)begin
           
			  for (i=0; i<= n-2; i=i+1)begin
             if(reg_in[i] > reg_in[i+1]) begin //Comparison operation
               reg_in[i] <= reg_in[i+1]; // Swapping
               reg_in[i+1] <= reg_in[i]; // swapping
             end
             reg_out[i] <= reg_in[i]; //Transferring input reg value to output registers.
           
			  end
           sort_count <= sort_count + 1'b1;
         
			end
           
			  if(sort_count == (n-1)) begin
             d_sort <= 1'b1;
			  end
       
		 end
       if(d_sort) begin
         data_out <= reg_out[addr_out];
         addr_out <= addr_out + 1'b1;
         addr_in <= 8'd0;
       end
   end
endmodule
