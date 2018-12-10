`timescale 1ns / 1ns


module top_direct_send(
   input select,
	input clk,
	input rst,
	input RsRx,																			// Connect to RX pin
	output [7:0] Rx_data,															// Received data
	output RsTx,																			// Connect to TX pin
	output [1:0] state
   );

	parameter CLK_RATE = 9600000;
	parameter BAUD_RATE = 9600;
	parameter SAMPLE_RATE = 10;

	wire clk_9_6M;
	wire uart_clk;
	wire sample_clk;
	wire sampler_data_out;
	wire tx_ready;																		// tx_ready signifies the availability of TX buffer
	wire rx_ready;																		// when signal == 1, signifies that one byte of data is received
	wire [7:0] data, data_out;																	// Received data
	reg tx_start;																		// start to send data when this bit is set to 1
	wire ready; //read to output
	assign Rx_data = data_out;



	receiver_sampler sampler(														// Error checking logic
		.rst(rst),
		.sample_clk(sample_clk),
		.rx_clk(uart_clk),
		.RsRx(RsRx),
		.data_bit(sampler_data_out)
		);

   receiver receiver(																// Receiver
		.data_in(sampler_data_out),
		//.data_in(RsRx),
		.rx_clk(uart_clk),
		.reset(rst),
		.signal(rx_ready),
		.data_out(data)
		);	
		
	//threshhold
//		RAM read(
//		//.en(tx_ready),
//		.reset(rst),
//		.clk(uart_clk), 
//		.in(data), 
//		.out(data_out),
//		.select(select),
//		.ready(ready)
//	);
	
	process process_int(
		.clk(clk_9_6M),
		.reset(rst),
		.valid_rx(rx_ready),
		.data_rx(data),
		.ready_tx(tx_ready),
	//input select,
		.data_out(data_out),
		.data_valid(ready),
		.state(state)
	);
	
	transmitter transmitter(														// Transmitter
		.data_in(data_out),
		.tx_clk(uart_clk),
		.reset(rst),
		.start(ready),
		.data_out(RsTx),
		.tx_ready(tx_ready)
		);						
	
	clk_divide																			// Clock generator for TX and RX
	#( .CLK_RATE(CLK_RATE),
		.BAUD_RATE(BAUD_RATE),
		.SAMPLE_RATE(SAMPLE_RATE))
	clk_div(																
		.clk(clk_9_6M),
		.rst(rst),
		.clk_uart(uart_clk),
		.clk_sampling(sample_clk)
		);															
	
	PLL_9_6M PLL(
		.clk_in(clk),
		.clk_out_9_6M(clk_9_6M),
		.rst(rst)
		);
//	
//	always @(rx_ready, tx_ready)
//		begin
//		if (tx_ready && rx_ready)													// start to send one byte of data after you received one
//			tx_start <= 1'b1;                                      // should change this part in order to use the mode 3, what the f*** is the "top" mentioned in matlab?
//		else
//			tx_start <= 1'b0;
//		end

endmodule
