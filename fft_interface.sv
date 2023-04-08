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
    output logic test_pin1,
    output logic test_pin2
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
logic [32:0] sink_data;
//Source Variables
logic        source_eop;
logic [2:0]  source_error;
logic        source_ready;
logic        source_valid;
logic        source_sop;
logic [32:0] source_data;

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
assign source_ready = 1;

// SQRT
logic           sqrt_start;
logic           sqrt_busy;
logic           sqrt_valid;
logic [31:0]    sqrt_rad;
logic [31:0]    sqrt_root;
logic [31:0]    sqrt_rem;

sqrt_int #(.WIDTH(32)) sqrt_0 (
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
logic new_sample;

// Samples the ADC every 1/FS seconds and initiates a FFT 
always_ff @(posedge clk or negedge reset_n) 
begin
    if(~reset_n) // Asyncronous Reset
    begin
        sample_count <= 0; 
        new_sample <= 0;
        samples[0] <= 0;
        samples[1] <= 0;
        samples[2] <= 0;
        samples[3] <= 0;
        samples[4] <= 0;
        samples[5] <= 0;
        samples[6] <= 0;
        samples[7] <= 0;
    end
    else if (sample_count >= FCLK-FS*2) //Clock Divider Samples every 1/FS seconds
    begin
        sample_count <= 0;
        //Samples Shift
        samples[1:7] <= samples[0:6]; //Shifts Samples over
        samples[0] <= ADC_result;  //Inputs latest sampled point
        //Start FFT
        new_sample <= 1;
    end
    else 
    begin
        sample_count <= sample_count + FS*2;
        new_sample <= 0;
    end
end

// FFT SINK
logic [3:0] current_sample;

// Input into the FFT module
always_ff @(posedge clk or negedge reset_n)
begin
    if(~reset_n)
    begin
        sink_data <= 0;
        current_sample <= 0;
        sink_eop <= 0;
        sink_sop <= 0;
        sink_valid <= 0;
    end
    else
    begin
        if(current_sample >= 8)
        begin
            sink_eop <= 0;
            sink_valid <= 0;
            current_sample <= 0;
        end
        else if(sink_valid)
        begin
            sink_data[32:19] <= samples[current_sample];
            sink_data[4:1] <= 3'b100;
            sink_data[0] <= 1'b0;

            sink_sop <= 0;
            current_sample <= current_sample + 1;
            if (current_sample >= 7)
                sink_eop <= 1;
        end
        else if(new_sample)
        begin
            sink_data[32:19] <= samples[current_sample];
            sink_data[4:1] <= 3'b100;
            sink_data[0] <= 1'b0;

            current_sample <= current_sample + 1;
            sink_sop <= 1;
            sink_valid <= 1;
        end
    end
end

//FFT SOURCE
logic [2:0] current_result;
logic signed [32:0] fft_result [7:0];

always_ff @(negedge clk or negedge reset_n)
begin
    if(~reset_n)
    begin
        current_result <= 0;
        fft_result[0] <= 0;
        fft_result[1] <= 0;
        fft_result[2] <= 0;
        fft_result[3] <= 0;
        fft_result[4] <= 0;
        fft_result[5] <= 0;
        fft_result[6] <= 0;
        fft_result[7] <= 0;
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
logic signed [31:0] fft_real;
logic signed [31:0] fft_img;

assign fft_real = fft_result[mag_count][32:19];
assign fft_img = fft_result[mag_count][18:5];

always_ff @(posedge clk or negedge reset_n) begin
    if(~reset_n)
    begin
        mag_count <= 0;
        sqrt_start <= 1;
        sqrt_rad <= 0;
        mag[0] <= 0;
        mag[1] <= 0;
        mag[2] <= 0;
        mag[3] <= 0;
        mag[4] <= 0;
        mag[5] <= 0;
        mag[6] <= 0;
        mag[7] <= 0;
    end
    else if(~sqrt_busy)
    begin
        if(sqrt_valid) 
        begin
              mag[mag_count-1] <= sqrt_root[12:0];
        end
        sqrt_start <= 1;
        sqrt_rad <= fft_real**2 + fft_img**2;
        mag_count <= mag_count + 1;
    end
    else
    begin
        sqrt_start <= 0;
    end
end



//Testing Pins
assign test_pin1 = sink_ready;
assign test_pin2 = source_ready;
endmodule