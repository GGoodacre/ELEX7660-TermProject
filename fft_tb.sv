// ELEX 7660 202010 Lab 3
// Testbench to test the ADC interface module
// Robert Trost 2020/1/21

`timescale 1ns / 1ps

module fft_tb();

logic clk, reset_n;			 // clock and reset
	
// ltc2308 signals
logic ADC_CONVST, ADC_SCK, ADC_SDI;
logic ADC_SDO = 0;
logic [11:0] adcoutput;

logic [12:0] mag [0:7];
logic [2:0] ADC_channel = 0;

fft_interface #(.FCLK(1000), .FS(100)) dut_0 (.*);  // device under test


initial begin
	clk = 0;
	reset_n = 0;
	// hold in reset for two clock cycles
	repeat(2) @(posedge clk);
	
	reset_n = 1;

    repeat(10000) @(posedge clk); 

		
	$stop;

end

always begin
    @(posedge ADC_CONVST);
		// generate a random n-bit ADC output
		adcoutput = $urandom_range('hfff, 0);

		for (int i = 12-1; i>=0; i--)	begin
			// place each data bit on SDO and wait for negative edge of serial clock to change output
			ADC_SDO = adcoutput[i];
		end	
end

// generate clock
always
	#1ms clk = ~clk;
	

endmodule

