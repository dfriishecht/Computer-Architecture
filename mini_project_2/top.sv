`include "cycle_color_pwm.sv"

module top(
    input logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);

    logic [9:0] pwm_counter;
    logic [9:0] pwm_red, pwm_green, pwm_blue;

    cycle_color_pwm u0(
        .clk (clk),
        .pwm_counter (pwm_counter),
        .pwm_red (pwm_red),
        .pwm_green (pwm_green),
        .pwm_blue (pwm_blue)
    );

    assign RGB_R = ~(pwm_counter < pwm_red);
    assign RGB_G = ~(pwm_counter < pwm_green);
    assign RGB_B = ~(pwm_counter < pwm_blue);

endmodule