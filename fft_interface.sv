// ELEX7660 Lab Project
// FFT Interface
// Garnett Goodacre
// 
// 2023-04-06
// Connects the ADC to the FFT module and outputs the magnitudes
localparam LENGTH = 16;
localparam FFT_LENGTH = 16;
localparam DATA = 12;
localparam OUTPUT = 17;


module fft_interface
   #( parameter FS,
      parameter FCLK
    )
    (
    //Control Signals
    input logic clk, reset_n,
    //DFT Resultant Magnitudes
    output logic [OUTPUT-1:0] mag [0:LENGTH-1],
    //ADC
    output logic ADC_CONVST, ADC_SCK, ADC_SDI,
    input logic ADC_SDO,
    input logic [2:0] ADC_channel,
    output logic test_pin1,
    output logic test_pin2,
    output logic [11:0] test_bus
);


///////////////////////////////////////////////////////////////////////////////////////////////////////
// ADC MODULE
///////////////////////////////////////////////////////////////////////////////////////////////////////
logic adc_clk;
pll pll0 ( .inclk0(clk), .c0(adc_clk) ) ;



logic signed [11:0] ADC_result;

adcinterface adcinterface_0(
    .clk(adc_clk),
    .reset_n,
    .chan(ADC_channel),
    .result(ADC_result),
    .ADC_CONVST,
    .ADC_SCK,
    .ADC_SDI,
    .ADC_SDO
);

///////////////////////////////////////////////////////////////////////////////////////////////////////
// FFT Module
///////////////////////////////////////////////////////////////////////////////////////////////////////
//Sink Variables
logic        sink_eop;
logic [2:0]  sink_error;
logic        sink_ready;
logic        sink_valid;
logic        sink_sop;
logic [DATA*2+$clog2(FFT_LENGTH)+1:0] sink_data;
//Source Variables
logic        source_eop;
logic [2:0]  source_error;
logic        source_ready;
logic        source_valid;
logic        source_sop;
logic [OUTPUT*2+$clog2(FFT_LENGTH):0] source_data;

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

///////////////////////////////////////////////////////////////////////////////////////////////////////
// SQRT
///////////////////////////////////////////////////////////////////////////////////////////////////////
logic           sqrt_start;
logic           sqrt_busy;
logic           sqrt_valid;
logic [35:0]    sqrt_rad;
logic [35:0]    sqrt_root;
logic [35:0]    sqrt_rem;

sqrt_int #(.WIDTH(36)) sqrt_0 (
        .clk    (clk),
        .start  (sqrt_start),
        .busy   (sqrt_busy),
        .valid  (sqrt_valid),
        .rad    (sqrt_rad),
        .root   (sqrt_root),
        .rem    (sqrt_rem)
    );

///////////////////////////////////////////////////////////////////////////////////////////////////////
// SAMPLING
///////////////////////////////////////////////////////////////////////////////////////////////////////
logic [31:0] sample_count;
logic [OUTPUT-1:0] samples [0:FFT_LENGTH-1];
logic signed [OUTPUT+1:0] corrected_samples [0:FFT_LENGTH-1];
logic new_sample;

logic signed [OUTPUT-1:0] test_samples [0:FFT_LENGTH-1];
always_comb
begin
    test_samples[0] = 2047;
    test_samples[1] = 2047;
    test_samples[2] = 2047;
    test_samples[3] = 2047;
    test_samples[4] = 2047;
    test_samples[5] = 2047;
    test_samples[6] = 2047;
    test_samples[7] = 2047;
    test_samples[8] = -2047;
    test_samples[9] = -2047;
    test_samples[10] = -2047;
    test_samples[11] = -2047;
    test_samples[12] = -2047;
    test_samples[13] = -2047;
    test_samples[14] = -2047;
    test_samples[15] = 2047;
end
// Samples the ADC every 1/FS seconds and initiates a FFT 
always_ff @(posedge clk or negedge reset_n) 
begin
    if(~reset_n) // Asyncronous Reset
    begin
        sample_count <= 0; 
        new_sample <= 0;
        for(int i = 0; i < FFT_LENGTH; i = i + 1)
        begin
            samples[i] <= '0;
        end
    end
    else if (sample_count >= FCLK-FS) //Clock Divider Samples every 1/FS seconds
    begin
        sample_count <= 0;
        //Samples Shift
        samples[0] <= ADC_result;  //Inputs latest sampled point]
        for(int i = 0; i < FFT_LENGTH-1; i = i + 1)
        begin
            samples[i+1] <= samples[i];
        end
        //Start FFT
        new_sample <= 1;
    end
    else 
    begin
        sample_count <= sample_count + FS;
        new_sample <= 0;
    end
end

always_comb
begin
    for(int i = 0; i < FFT_LENGTH; i = i + 1)
    begin
        corrected_samples[i] <= samples[i]-2048;
    end
end
///////////////////////////////////////////////////////////////////////////////////////////////////////
// FFT SINK
///////////////////////////////////////////////////////////////////////////////////////////////////////
logic [$clog2(FFT_LENGTH)+1:0] current_sample;

localparam sink_real_start = DATA*2+$clog2(FFT_LENGTH)+1;
localparam sink_real_end = DATA+$clog2(FFT_LENGTH)+2;
localparam sink_img_start = DATA+$clog2(FFT_LENGTH)+1;
localparam sink_img_end = $clog2(FFT_LENGTH)+2;
localparam ffpts = $clog2(FFT_LENGTH)+1;

//NOT USED
assign sink_data[ffpts-1:0] = '0;
assign sink_data[sink_img_start:sink_img_end] = '0;

// Input into the FFT module
always_ff @(posedge clk or negedge reset_n)
begin
    if(~reset_n)
    begin
        sink_data[sink_real_start:sink_real_end] <= 0;
        sink_data[ffpts] <= 1;

        current_sample <= 0;
        sink_eop <= 0;
        sink_sop <= 0;
        sink_valid <= 0;
    end
    else
    begin
        if(current_sample >= FFT_LENGTH)
        begin
            sink_eop <= 0;
            sink_valid <= 0;
            current_sample <= 0;
        end
        else if(sink_valid&sink_ready)
        begin
            sink_data[sink_real_start:sink_real_end] <= corrected_samples[current_sample][OUTPUT-1:0];
            sink_data[ffpts] <= 1;

            sink_sop <= 0;
            current_sample <= current_sample + 1;
            if (current_sample >= FFT_LENGTH-1)
                sink_eop <= 1;
        end
        else if(new_sample&sink_ready&~source_valid)
        begin
            sink_data[sink_real_start:sink_real_end] <= corrected_samples[current_sample][OUTPUT-1:0];
            sink_data[ffpts] <= 1;

            current_sample <= current_sample + 1;
            sink_sop <= 1;
            sink_valid <= 1;
        end
    end
end

///////////////////////////////////////////////////////////////////////////////////////////////////////
//FFT SOURCE
///////////////////////////////////////////////////////////////////////////////////////////////////////
localparam source_real_start = OUTPUT*2+$clog2(FFT_LENGTH);
localparam source_real_end = OUTPUT+$clog2(FFT_LENGTH)+1;
localparam source_img_start = OUTPUT+$clog2(FFT_LENGTH);
localparam source_img_end = $clog2(FFT_LENGTH)+1;

logic [$clog2(LENGTH):0] current_result;
logic [source_real_start:0] fft_result [0:LENGTH-1];
logic fft_lock;

always_ff @(negedge clk or negedge reset_n)
begin
    if(~reset_n)
    begin
        current_result <= 0;
        fft_lock <= 0;
        for(int i = 0; i < LENGTH; i = i + 1)
        begin
            fft_result[i] <= '0;
        end
    end
    else
    begin
        if(source_valid)
        begin
            if(~fft_lock)
            begin
            fft_result[current_result] <= source_data;
            current_result <= current_result + 1;
            end
            if(current_result == 15)
                fft_lock <= 1;
        end
        else
        begin
            current_result <= 0;
            fft_lock <= 0;
        end
    end
end

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Magnitude Calculation
///////////////////////////////////////////////////////////////////////////////////////////////////////
logic [$clog2(LENGTH):0] mag_count;
logic [35:0] fft_real;
logic [35:0] fft_img;
logic sqrt_lock;

always_comb
begin
    fft_real = fft_result[mag_count][source_real_start:source_real_end];
    fft_img = fft_result[mag_count][source_img_start:source_img_end];
    if(fft_real[16] == 1'b1)
        fft_real[16:0] = ~(fft_real[16:0]-1);
    else
        fft_real = fft_real;
    if(fft_img[16] == 1'b1)
        fft_img[16:0] = ~(fft_img[16:0]-1);
    else
        fft_img = fft_img;    
end

always_ff @(posedge clk or negedge reset_n) begin
    if(~reset_n)
    begin
        mag_count <= 0;
        sqrt_start <= 1;
        sqrt_rad <= 0;
        for(int i = 0; i < LENGTH; i = i + 1)
        begin
            mag[i] <= '0;
        end
        sqrt_lock <= 0;
    end
    else if(~sqrt_busy&~sqrt_lock)
    begin
        if(sqrt_valid) 
        begin
            if(mag_count == 0)
                mag[15] <= sqrt_root[OUTPUT-1:0];
            else
                mag[mag_count-1] <= sqrt_root[OUTPUT-1:0];
        end
        sqrt_start <= 1;
        sqrt_lock <= 1;
        sqrt_rad <= (fft_real*fft_real) + (fft_img*fft_img);
        mag_count <= mag_count + 1;
    end
    else
    begin
        sqrt_start <= 0;
        sqrt_lock <= 0;
    end
end

///////////////////////////////////////////////////////////////////////////////////////////////////////
//Testing Pins
///////////////////////////////////////////////////////////////////////////////////////////////////////
assign test_pin1 = sink_valid;
assign test_pin2 = source_valid;
assign test_bus = samples[0];

endmodule