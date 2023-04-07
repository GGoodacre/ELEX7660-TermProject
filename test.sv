
module test(
    input logic CLOCK_50, reset_n,
    output logic pulseOut,
    output logic testything,
    output logic clk500
    );

    logic clk;
    assign clk = CLOCK_50;
    assign testything = CLOCK_50;

    logic onOff;
    logic [11:0] magnitude;

    servo servo_0 (.*); // 50MHz clock

endmodule