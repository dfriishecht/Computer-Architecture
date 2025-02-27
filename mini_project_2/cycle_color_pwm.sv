/*
Requirements:

- drive RGB LED to cycle smoothly through the entire hue spectrum once per second
    - use a PWM signal for each color to modulate their intensity
*/

module cycle_color_pwm #(
    parameter COLOR_INTERVAL = 46875 // (12mHz / 256) for integer color interval
)(
    input logic clk,
    output logic [9:0] pwm_counter,
    output logic [9:0] pwm_red,
    output logic [9:0] pwm_green,
    output logic [9:0] pwm_blue
);

    // Define variables for counting color transitions
    logic [$clog2(COLOR_INTERVAL) - 1:0] counter;
    logic [7:0] hue;


    initial begin
        counter = 0;
        hue = 0;
        pwm_counter = 0;

    end

    // Hue Transition (Sequential)
    always_ff @(posedge clk) begin
        if (counter >= COLOR_INTERVAL) begin
            counter <= 0;
            hue <= hue + 1; // overflow at 255
        end else begin
            counter <= counter + 1;
        end
        pwm_counter <= pwm_counter + 1; //overflows to reset
    end

    // Hue Assignment Logic (Combinational)
    always_comb begin
        if (hue < 43) begin
            pwm_red = 1023;
            pwm_green = (hue * 24);  // Interpolates from 0 → max
            pwm_blue = 0;
        end else if (hue < 85) begin
            pwm_red = ((85 - hue) * 24);
            pwm_green = 1023;
            pwm_blue = 0;
        end else if (hue < 128) begin
            pwm_red = 0;
            pwm_green = 1023;
            pwm_blue = ((hue - 85) * 24);
        end else if (hue < 171) begin
            pwm_red = 0;
            pwm_green = ((171 - hue) * 24 > 1023) ? 1023 : (171 - hue) * 24;
            pwm_blue = 1023;
        end else if (hue < 213) begin
            pwm_red = ((hue - 171) * 24);
            pwm_green = 0;
            pwm_blue = 1023;
        end else begin
            pwm_red = 1023;
            pwm_green = 0;
            pwm_blue = ((255 - hue) * 24);
        end
    end

endmodule