module servo_tb();

    logic reset_n;
    logic onOff;
    logic clk = 0;
    logic [11:0] magnitude;
    logic pulseOut;
    logic clk500;

    servo dut_0(.*);

    initial begin
        reset_n = 0;
        repeat(10) @(negedge clk);
        reset_n = 1;

        repeat(1000000) @(negedge clk);

        $stop;
    end

    // 50MHz clock
   always
     #20ns clk = ~clk ;

endmodule