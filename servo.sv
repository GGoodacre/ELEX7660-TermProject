// servo.sv
// Kurt Querengesser
// A01169042 Set S
// 2023-04-07

// A module to take in a 12 bit input and map 
// it to a servo output position using PWM at 50Hz

module servo(
    input logic reset_n, onOff, clk,
    input logic [11:0] magnitude,
    output logic pulseOut,
    output logic clk500
    );

    logic [31:0] count500;
    logic [31:0] timeCount;
    //logic clk500;
    logic [6:0] duty;

    assign duty = 12;

    // generate 500Hz clock
    always_ff @( posedge clk ) begin
        if (reset_n) begin
            if (count500 < 10000/2-1) begin // assuming 50MHz clock
                count500 <= count500 + 1;
            end else begin
                clk500 <= ~clk500;
                count500 <= 0;
            end
        end else begin
            count500 <= 0;
            clk500 <= 0;
        end
    end

    // generate pwm
    always_ff @( posedge clk500 ) begin
        if (reset_n) begin
            // pulse
            if (timeCount < 100) begin
                    if (timeCount < duty)
                        pulseOut <= 1;
                    else
                        pulseOut <= 0;
                timeCount <= timeCount + 1;
            end else begin
                timeCount <= 1;
                pulseOut <= 1;
            end
                
        end else begin
            timeCount <= 0;
            pulseOut <= 0;
        end
    end

endmodule