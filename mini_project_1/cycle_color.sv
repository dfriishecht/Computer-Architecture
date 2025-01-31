// Color Cycling State Machine

/*
Requirements:

- drive RGB LED to cycle through RED, YELLOW, GREEN, CYAN, BLUE, and MAGENTA once per second
    - Given a clock speed of 12MHz, this equates to 2Mhz per color
*/

module cycle_color #(

    parameter COLOR_INTERVAL = 2000000 //~0.167 seconds with 12MHz clock
)(
    input logic clk,
    output logic red,
    output logic green,
    output logic blue
);

    // Define state variable values
    // With 6 states, need 3 bits total
    localparam  RED = 3'b000;
    localparam YELLOW = 3'b001;
    localparam GREEN = 3'b010;
    localparam CYAN = 3'b011;
    localparam BLUE = 3'b100;
    localparam MAGENTA = 3'b101;

    // Declare state variables
    logic [2:0] current_state = RED; // bit width of 3 to store up to 8 different values.
    logic [2:0] next_state;

    // Declare next output variables to determine color blend.
    logic next_red, next_green, next_blue;

    // Declare counter variables for state switching
    logic [$clog2(COLOR_INTERVAL) - 1:0] count = 0;
    

    // State-Register (Sequential)
    always_ff @(posedge clk) // trigger on rising edge clock
        current_state <= next_state; // Update the current state

    // State-Logic (Combinational)
    always_comb begin
        next_state = 3'bxxx; // default undefined state
        case (current_state)
            RED:
                if (count == COLOR_INTERVAL - 1) begin
                    next_state = YELLOW;
                end
                else
                    next_state = RED;
            YELLOW:
                if (count == COLOR_INTERVAL - 1) begin
                    next_state = GREEN;
                end
                else
                    next_state = YELLOW;
            GREEN:
                if (count == COLOR_INTERVAL - 1) begin
                    next_state = CYAN;
                end
                else
                    next_state = GREEN;
            CYAN:
                if (count == COLOR_INTERVAL - 1) begin
                    next_state = BLUE;
                end
                else
                    next_state = CYAN;
            BLUE:
                if (count == COLOR_INTERVAL - 1) begin
                    next_state = MAGENTA;
                end
                else
                    next_state = BLUE;
            MAGENTA:
                if (count == COLOR_INTERVAL - 1) begin
                    next_state = RED;
                end
                else
                    next_state = MAGENTA;
        endcase
    end

    // Counting-Register (Sequential)
    always_ff @(posedge clk) begin
        if (count == COLOR_INTERVAL - 1)
            count <= 0;
        else
            count <= count + 1;
    end

    // Output-Register (Sequential)
    always_ff @(posedge clk) begin
        red <= next_red;
        green <= next_green;
        blue <= next_blue;
    end

    // Output-Logic (Combinational)
    always_comb begin
        next_red = 1'b0;
        next_green = 1'b0;
        next_blue = 1'b0;
        case (current_state)
            RED:
                next_red = 1'b1;
            YELLOW: begin
                next_red = 1'b1;
                next_green = 1'b1;
            end
            GREEN:
                next_green = 1'b1;
            CYAN: begin
                next_green = 1'b1;
                next_blue = 1'b1;
            end
            BLUE:
                next_blue = 1'b1;
            MAGENTA: begin
                next_blue = 1'b1;
                next_red = 1'b1;
            end
        endcase
    end

endmodule