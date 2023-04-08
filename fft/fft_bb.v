
module fft (
	clk_clk,
	reset_reset_n,
	sink_valid,
	sink_ready,
	sink_error,
	sink_startofpacket,
	sink_endofpacket,
	sink_data,
	source_valid,
	source_ready,
	source_error,
	source_startofpacket,
	source_endofpacket,
	source_data);	

	input		clk_clk;
	input		reset_reset_n;
	input		sink_valid;
	output		sink_ready;
	input	[1:0]	sink_error;
	input		sink_startofpacket;
	input		sink_endofpacket;
	input	[28:0]	sink_data;
	output		source_valid;
	input		source_ready;
	output	[1:0]	source_error;
	output		source_startofpacket;
	output		source_endofpacket;
	output	[27:0]	source_data;
endmodule
