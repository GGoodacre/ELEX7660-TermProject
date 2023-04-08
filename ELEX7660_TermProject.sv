module ELEX7660_TermProject (
              (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *)
			  output ADC_CONVST, ADC_SCK, ADC_SDI,  // ADC interface
              input ADC_SDO,
              input logic  reset_n, FPGA_CLK1_50,
              output logic servo_pulse [4:0],
              output logic test_pin1, test_pin2
              ) ;
  
    logic [12:0] mag [0:7];
    fft_interface #(.FCLK(50000000), .FS(2000)) fft_0 
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .mag(mag),
            .ADC_CONVST(ADC_CONVST),
            .ADC_SCK(ADC_SCK),
            .ADC_SDI(ADC_SDI),
            .ADC_SDO(ADC_SDO),
            .ADC_channel(0),
            .test_pin1(test_pin1),
            .test_pin2(test_pin2)
        );
    servo servo_0
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[0]),
            .pulseOut(servo_pulse[0])
        );
    servo servo_1
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[1]),
            .pulseOut(servo_pulse[1])
        );

endmodule