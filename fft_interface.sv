// ELEX7660 Lab Project
// FFT Interface
// Garnett Goodacre
// 
// 2023-04-06
// Connects the ADC to the FFT module and outputs the magnitudes

module fft_interface
   #( parameter FS,
      parameter FCLK
    )
    (
    //Control Signals
    input logic clk, reset_n,
    //DFT Resultant Magnitudes
    output logic [12:0] mag [0:7],
    //ADC
    output logic ADC_CONVST, ADC_SCK, ADC_SDI,
    input logic ADC_SDO,
    input logic [2:0] ADC_channel,
    output logic o_sqrt_busy,
    output logic o_sqrt_valid
);

// ADC MODULE
logic [11:0] ADC_result;

adcinterface adcinterface_0(
    .clk,
    .reset_n,
    .chan(ADC_channel),
    .result(ADC_result),
    .ADC_CONVST,
    .ADC_SCK,
    .ADC_SDI,
    .ADC_SDO
);

// FFT Module
//Sink Variables
logic        sink_eop;
logic [2:0]  sink_error;
logic        sink_ready;
logic        sink_valid;
logic        sink_sop;
logic [28:0] sink_data;
//Source Variables
logic        source_eop;
logic [2:0]  source_error;
logic        source_ready;
logic        source_valid;
logic        source_sop;
logic [28:0] source_data;

fft fft_0 (
		.clk_clk              (clk),            //    clk.clk
		.reset_reset_n        (reset_n),        //  reset.reset_n
		.sink_valid           (sink_valid),     //   sink.valid
		.sink_ready           (sink_ready),     //       .ready
		.sink_error           (sink_error),     //       .error
		.sink_startofpacket   (sink_sop),       //       .startofpacket
		.sink_endofpacket     (sink_eop),       //       .endofpacket
		.sink_data            (sink_data),      //       .data
		.source_valid         (source_valid),   // source.valid
		.source_ready         (source_ready),   //       .ready
		.source_error         (source_error),   //       .error
		.source_startofpacket (source_sop),     //       .startofpacket
		.source_endofpacket   (source_eop),     //       .endofpacket
		.source_data          (source_data)     //       .data
	);

// NOT USED
assign sink_error = 2'b00;

// SQRT
logic           sqrt_start;
logic           sqrt_busy;
logic           sqrt_valid;
logic [24:0]    sqrt_rad;
logic [24:0]    sqrt_root;
logic [24:0]    sqrt_rem;

assign o_sqrt_busy = sqrt_busy;
assign o_sqrt_valid = sqrt_valid;

sqrt_int #(.WIDTH(25)) sqrt_0 (
        .clk    (clk),
        .start  (sqrt_start),
        .busy   (sqrt_busy),
        .valid  (sqrt_valid),
        .rad    (sqrt_rad),
        .root   (sqrt_root),
        .rem    (sqrt_rem)
    );


// SAMPLING
logic [31:0] sample_count;
logic [11:0] samples [0:7];

// Samples the ADC every 1/FS seconds and initiates a FFT 
always_ff @(posedge clk or negedge reset_n) 
begin
    if(~reset_n) // Asyncronous Reset
    begin
        sample_count <= 0; 
        sink_sop <= 0;
        sink_valid <= 0;
        samples <= '{default: '0};
    end
    else if (sample_count >= FCLK-FS) //Clock Divider Samples every 1/FS seconds
    begin
        sample_count <= 0;
        //Samples Shift
        samples[1:7] <= samples[0:6]; //Shifts Samples over
        samples[0] <= ADC_result;  //Inputs latest sampled point
        //Start FFT
        sink_sop <= 1; //
        sink_valid <= 1;
    end
    else if (sample_count >= 7)
        sink_valid <= 0;
    else 
    begin
        sample_count <= sample_count + FS;
        sink_sop <= 0;
    end
end

// FFT SINK
logic [2:0] current_sample;

// Input into the FFT module
always_ff @(posedge clk or negedge reset_n)
begin
    if(~reset_n)
    begin
        sink_data <= 0;
        current_sample <= 1;
        sink_eop <= 0;
    end
    else
    begin
        if(sink_valid)
        begin
            sink_data[28:17] <= samples[current_sample];
            current_sample <= current_sample + 1;
            if (current_sample >= 6)
                sink_eop <= 1;
        end
        else
        begin
            sink_data <= samples[0];
            current_sample <= 1;
            sink_eop <= 0;
        end
    end
end

//FFT SOURCE
logic [2:0] current_result;
logic signed [28:0] fft_result [7:0];

always_ff @(posedge clk or negedge reset_n)
begin
    if(~reset_n)
    begin
        current_result <= 0;
        fft_result <= '{default: '0};
    end
    else
    begin
        if(source_valid)
        begin
            if (current_result < 8)
            begin
                fft_result[current_result] <= source_data;
                current_result <= current_result + 1;
            end
        end
        else
        begin
            current_result <= 0;
        end
    end
end

// Magnitude Calculation
logic [2:0] mag_count;

always_ff @(posedge clk or negedge reset_n) begin
    if(~reset_n)
    begin
        mag_count <= 0;
        sqrt_start <= 1;
        sqrt_rad <= 0;
        mag = '{default: '0};
    end
    else if(~sqrt_busy)
    begin
        if(sqrt_valid) 
        begin
              mag[mag_count-1] <= 300;
        end
        sqrt_start <= 1;
        sqrt_rad <= fft_result[mag_count][28:17]**2 + fft_result[mag_count][16:5]**2 + 2000**2;
        mag_count = mag_count++;
    end
    else
    begin
        sqrt_start <= 0;
    end
end


endmodule