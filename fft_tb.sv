// ELEX 7660 202010 Lab 3
// Testbench to test the ADC interface module
// Robert Trost 2020/1/21

`timescale 1ns / 1ps

module fft_tb();

logic clk, reset_n;			 // clock and reset
	
logic ADC_CONVST, ADC_SCK, ADC_SDI;
logic ADC_SDO = 0;
logic [11:0] adcoutput;

logic [16:0] mag [0:15];
logic [2:0] ADC_channel = 0;
logic test_pin1, test_pin2;
logic [11:0] test_bus;


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

// generate clock
always
	#1ms clk = ~clk;
	

endmodule

