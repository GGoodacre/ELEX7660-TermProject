// ELEX7660 Lab Project
// Garnett Goodacre
// 
// 2023-04-06

module dft(
    //Control Signals
    input logic clk, reset_n,
    output logic valid,
    //DFT Resultant Magnitudes
    output logic signed [31:0] mag [4:0],
    //ADC
    output ADC_CONVST, ADC_SCK, ADC_SDI,
    input ADC_SDO
    input logic [2:0] ADC_channel
);

// ADC MODULE
logic [11:0] ADC_result

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

// DFT COEFFICIENTS
logic [4:0] real [4:0][4:0];
logic [4:0] img [4:0][4:0];

assign real[4:0][0][0] = 'h10; assign real[4:0][0][1] = 'h10; assign real[4:0][0][2] = 'h10; assign real[4:0][0][3] = 'h10; assign real[4:0][0][4] = 'h10;
assign real[4:0][1][0] = 'h10; assign real[4:0][1][1] = 'h10; assign real[4:0][1][2] = 'h10; assign real[4:0][1][3] = 'h10; assign real[4:0][1][4] = 'h10;
assign real[4:0][2][0] = 'h10; assign real[4:0][2][1] = 'h10; assign real[4:0][2][2] = 'h10; assign real[4:0][2][3] = 'h10; assign real[4:0][2][4] = 'h10;
assign real[4:0][3][0] = 'h10; assign real[4:0][3][1] = 'h10; assign real[4:0][3][2] = 'h10; assign real[4:0][3][3] = 'h10; assign real[4:0][3][4] = 'h10;
assign real[4:0][4][0] = 'h10; assign real[4:0][4][1] = 'h10; assign real[4:0][4][2] = 'h10; assign real[4:0][4][3] = 'h10; assign real[4:0][4][4] = 'h10;

assign img[4:0][0][0] = 'h0; assign img[4:0][0][1] = 'h0; assign img[4:0][0][2] = 'h0; assign img[4:0][0][3] = 'h0; assign img[4:0][0][4] = 'h0;
assign img[4:0][1][0] = 'h10; assign img[4:0][1][1] = 'h10; assign img[4:0][1][2] = 'h10; assign img[4:0][1][3] = 'h10; assign img[4:0][1][4] = 'h10;
assign img[4:0][2][0] = 'h10; assign img[4:0][2][1] = 'h10; assign img[4:0][2][2] = 'h10; assign img[4:0][2][3] = 'h10; assign img[4:0][2][4] = 'h10;
assign img[4:0][3][0] = 'h10; assign img[4:0][3][1] = 'h10; assign img[4:0][3][2] = 'h10; assign img[4:0][3][3] = 'h10; assign img[4:0][3][4] = 'h10;
assign img[4:0][4][0] = 'h10; assign img[4:0][4][1] = 'h10; assign img[4:0][4][2] = 'h10; assign img[4:0][4][3] = 'h10; assign img[4:0][4][4] = 'h10;







endmodule