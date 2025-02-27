`timescale 1ns/1ns
`include "top.sv"

module cycle_color_tb;


    logic clk = 0;
    logic RGB_R;
    logic RGB_G;
    logic RGB_B;

    top top (
        .clk (clk),
        .RGB_R(RGB_R),
        .RGB_G(RGB_G),
        .RGB_B(RGB_B)
    );

    always begin
        #41.6667 clk = ~clk;
    end

    initial begin
        clk = 0;
        $dumpfile("cycle_color_pwm.vcd");
        $dumpvars(0, top);
        #1000000000;
        $finish;
    end

endmodule

