	fft u0 (
		.clk_clk              (<connected-to-clk_clk>),              //    clk.clk
		.reset_reset_n        (<connected-to-reset_reset_n>),        //  reset.reset_n
		.sink_valid           (<connected-to-sink_valid>),           //   sink.valid
		.sink_ready           (<connected-to-sink_ready>),           //       .ready
		.sink_error           (<connected-to-sink_error>),           //       .error
		.sink_startofpacket   (<connected-to-sink_startofpacket>),   //       .startofpacket
		.sink_endofpacket     (<connected-to-sink_endofpacket>),     //       .endofpacket
		.sink_data            (<connected-to-sink_data>),            //       .data
		.source_valid         (<connected-to-source_valid>),         // source.valid
		.source_ready         (<connected-to-source_ready>),         //       .ready
		.source_error         (<connected-to-source_error>),         //       .error
		.source_startofpacket (<connected-to-source_startofpacket>), //       .startofpacket
		.source_endofpacket   (<connected-to-source_endofpacket>),   //       .endofpacket
		.source_data          (<connected-to-source_data>)           //       .data
	);

