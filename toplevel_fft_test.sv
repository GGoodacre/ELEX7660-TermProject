// ELEX 7660 202010 Lab 3
// Use 4x4 keypad for ADC channel selection and ouput result on 7-seg LED display
// Robert Trost 2020/1/21

module toplevel_fft_test (
              (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *)
			  output ADC_CONVST, ADC_SCK, ADC_SDI,  // ADC interface
              input ADC_SDO,
              input logic  reset_n, CLOCK_50,
              output logic[12:0] mag [0:7]) ;
  
   // modules from labs 1 & 2
    fft_interface #(.FCLK(50000000), .FS(2000)) fft_0 
        (
            .clk(CLOCK_50),
            .reset_n(reset_n),
            .mag(mag),
            .ADC_CONVST(ADC_CONVST),
            .ADC_SCK(ADC_SCK),
            .ADC_SDI(ADC_SDI),
            .ADC_SDO(ADC_SDO),
            .ADC_channel(0)
        );

endmodule