// fft.v

// Generated using ACDS version 18.1 625

`timescale 1 ps / 1 ps
module fft (
		input  wire        clk_clk,              //    clk.clk
		input  wire        reset_reset_n,        //  reset.reset_n
		input  wire        sink_valid,           //   sink.valid
		output wire        sink_ready,           //       .ready
		input  wire [1:0]  sink_error,           //       .error
		input  wire        sink_startofpacket,   //       .startofpacket
		input  wire        sink_endofpacket,     //       .endofpacket
		input  wire [28:0] sink_data,            //       .data
		output wire        source_valid,         // source.valid
		input  wire        source_ready,         //       .ready
		output wire [1:0]  source_error,         //       .error
		output wire        source_startofpacket, //       .startofpacket
		output wire        source_endofpacket,   //       .endofpacket
		output wire [27:0] source_data           //       .data
	);

	wire         rst_controller_reset_out_reset; // rst_controller:reset_out -> fft_ii_0:reset_n
	wire  [11:0] fft_ii_0_source_imag;           // port fragment
	wire  [11:0] fft_ii_0_source_real;           // port fragment
	wire   [3:0] fft_ii_0_fftpts_out;            // port fragment

	fft_fft_ii_0 fft_ii_0 (
		.clk          (clk_clk),                         //    clk.clk
		.reset_n      (~rst_controller_reset_out_reset), //    rst.reset_n
		.sink_valid   (sink_valid),                      //   sink.valid
		.sink_ready   (sink_ready),                      //       .ready
		.sink_error   (sink_error),                      //       .error
		.sink_sop     (sink_startofpacket),              //       .startofpacket
		.sink_eop     (sink_endofpacket),                //       .endofpacket
		.sink_real    (sink_data[28:17]),                //       .data
		.sink_imag    (sink_data[16:5]),                 //       .data
		.fftpts_in    (sink_data[4:1]),                  //       .data
		.inverse      (sink_data[0]),                    //       .data
		.source_valid (source_valid),                    // source.valid
		.source_ready (source_ready),                    //       .ready
		.source_error (source_error),                    //       .error
		.source_sop   (source_startofpacket),            //       .startofpacket
		.source_eop   (source_endofpacket),              //       .endofpacket
		.source_real  (fft_ii_0_source_real[11:0]),      //       .data
		.source_imag  (fft_ii_0_source_imag[11:0]),      //       .data
		.fftpts_out   (fft_ii_0_fftpts_out[3:0])         //       .data
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (0),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~reset_reset_n),                 // reset_in0.reset
		.clk            (clk_clk),                        //       clk.clk
		.reset_out      (rst_controller_reset_out_reset), // reset_out.reset
		.reset_req      (),                               // (terminated)
		.reset_req_in0  (1'b0),                           // (terminated)
		.reset_in1      (1'b0),                           // (terminated)
		.reset_req_in1  (1'b0),                           // (terminated)
		.reset_in2      (1'b0),                           // (terminated)
		.reset_req_in2  (1'b0),                           // (terminated)
		.reset_in3      (1'b0),                           // (terminated)
		.reset_req_in3  (1'b0),                           // (terminated)
		.reset_in4      (1'b0),                           // (terminated)
		.reset_req_in4  (1'b0),                           // (terminated)
		.reset_in5      (1'b0),                           // (terminated)
		.reset_req_in5  (1'b0),                           // (terminated)
		.reset_in6      (1'b0),                           // (terminated)
		.reset_req_in6  (1'b0),                           // (terminated)
		.reset_in7      (1'b0),                           // (terminated)
		.reset_req_in7  (1'b0),                           // (terminated)
		.reset_in8      (1'b0),                           // (terminated)
		.reset_req_in8  (1'b0),                           // (terminated)
		.reset_in9      (1'b0),                           // (terminated)
		.reset_req_in9  (1'b0),                           // (terminated)
		.reset_in10     (1'b0),                           // (terminated)
		.reset_req_in10 (1'b0),                           // (terminated)
		.reset_in11     (1'b0),                           // (terminated)
		.reset_req_in11 (1'b0),                           // (terminated)
		.reset_in12     (1'b0),                           // (terminated)
		.reset_req_in12 (1'b0),                           // (terminated)
		.reset_in13     (1'b0),                           // (terminated)
		.reset_req_in13 (1'b0),                           // (terminated)
		.reset_in14     (1'b0),                           // (terminated)
		.reset_req_in14 (1'b0),                           // (terminated)
		.reset_in15     (1'b0),                           // (terminated)
		.reset_req_in15 (1'b0)                            // (terminated)
	);

	assign source_data = { fft_ii_0_source_real[11:0], fft_ii_0_source_imag[11:0], fft_ii_0_fftpts_out[3:0] };

endmodule