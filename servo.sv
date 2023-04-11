// servo.sv
// Kurt Querengesser
// A01169042 Set S
// 2023-04-07

// A module to take in a 13 bit input and map 
// it to a servo output position using PWM at 50Hz

module servo(
    input logic reset_n, clk,
    input logic [16:0] magnitude,
    output logic pulseOut
    );

    localparam dutyFactor = 24000; // factor for conversion from magnitude to duty cycle

    logic [31:0] count500;
    logic [31:0] timeCount;
    logic clk500;
    logic [31:0] duty;

    // generate 500Hz clock
    always_ff @(posedge clk or negedge reset_n) 
    begin
        if (~reset_n) 
        begin
            count500 <= 0;
            clk500 <= 0;
        end
        else
        begin
            if (count500 < 10000/2-1) 
            begin // assuming 50MHz clock
                count500 <= count500 + 1;
            end 
            else 
            begin
                clk500 <= ~clk500;
                count500 <= 0;
            end
        end
    end

    // generate pwm
    always_ff @(posedge clk500 or negedge reset_n)
    begin
        if (~reset_n)
        begin
            timeCount <= 0;
            pulseOut <= 0;
        end
        else
        begin
            // pulse
            if (timeCount < 100 * dutyFactor) 
            begin
                    if (timeCount < duty)
                        pulseOut <= 1;
                    else
                        pulseOut <= 0;
                timeCount <= timeCount + 1*dutyFactor;
            end 
            else 
            begin
                timeCount <= 1*dutyFactor;
                pulseOut <= 1;
                duty <= (100*magnitude)<(95*dutyFactor) ? 100*magnitude : 95*dutyFactor;
            end        
        end
    end

endmodule