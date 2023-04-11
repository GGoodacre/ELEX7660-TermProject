module ELEX7660_TermProject (
              (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *)
			  output logic ADC_CONVST, ADC_SCK, ADC_SDI,  // ADC interface
              input logic ADC_SDO,
              input logic  reset_n, FPGA_CLK1_50,
              output logic servo_pulse [15:0],
              output logic test_pin1, test_pin2,
              output logic [11:0] test_bus
              ) ;
  

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //RESET_N   
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    
    logic [1:0] reset_count;
    logic sync_reset_n;

    always_ff @(negedge FPGA_CLK1_50 or negedge reset_n)
    begin
        if(~reset_n)
        begin
            sync_reset_n <= 0;
            reset_count <= 2;
        end
        else if(~(|reset_count))
        begin
            sync_reset_n <= 1;
        end
        else
        begin
            reset_count <= reset_count - 1;
        end
    end
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //MODULES  
    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    logic [16:0] mag [0:15];
    fft_interface #(.FCLK(50000000), .FS(1600)) fft_0 
        (
            .clk(FPGA_CLK1_50),
            .reset_n(sync_reset_n),
            .mag(mag),
            .ADC_CONVST(ADC_CONVST),
            .ADC_SCK(ADC_SCK),
            .ADC_SDI(ADC_SDI),
            .ADC_SDO(ADC_SDO),
            .ADC_channel(0),
            .test_pin1(test_pin1),
            .test_pin2(test_pin2),
            .test_bus(test_bus)
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
    servo servo_2
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[2]),
            .pulseOut(servo_pulse[2])
        );
    servo servo_3
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[3]),
            .pulseOut(servo_pulse[3])
        );
    servo servo_4
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[4]),
            .pulseOut(servo_pulse[4])
        );
    servo servo_5
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[5]),
            .pulseOut(servo_pulse[5])
        );
    servo servo_6
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[6]),
            .pulseOut(servo_pulse[6])
        );
    servo servo_7
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[7]),
            .pulseOut(servo_pulse[7])
        );
    servo servo_8
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[8]),
            .pulseOut(servo_pulse[8])
        );
    servo servo_9
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[9]),
            .pulseOut(servo_pulse[9])
        );
    servo servo_10
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[10]),
            .pulseOut(servo_pulse[10])
        );
    servo servo_11
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[11]),
            .pulseOut(servo_pulse[11])
        );
    servo servo_12
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[12]),
            .pulseOut(servo_pulse[12])
        );
    servo servo_13
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[13]),
            .pulseOut(servo_pulse[13])
        );
    servo servo_14
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[14]),
            .pulseOut(servo_pulse[14])
        );
    servo servo_15
        (
            .clk(FPGA_CLK1_50),
            .reset_n(reset_n),
            .magnitude(mag[15]),
            .pulseOut(servo_pulse[15])
        );
endmodule