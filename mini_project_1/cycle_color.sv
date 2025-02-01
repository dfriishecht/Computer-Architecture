// Color Cycling State Machine

/*
Requirements:

- drive RGB LED to cycle through RED, YELLOW, GREEN, CYAN, BLUE, and MAGENTA once per second
    - Given a clock speed of 12MHz, this equates to 2 million clock cycles per color
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
    typedef enum logic [2:0] {
        RED      = 3'b000,
        YELLOW   = 3'b001,
        GREEN    = 3'b010,
        CYAN     = 3'b011,
        BLUE     = 3'b100,
        MAGENTA  = 3'b101
    } t_state;

    // Declare state variables
    t_state current_state = RED;
    t_state next_state;

    // Declare next output variables to determine color blend.
    logic next_red, next_green, next_blue;
 
    // Declare counter variable for state switching
    logic [($clog2(COLOR_INTERVAL))-1:0] count = 0;
    
    // State Transition (Sequential)
    always_ff @(posedge clk) begin // trigger on rising edge clock
        if (count == COLOR_INTERVAL - 1) begin
            current_state <= next_state;
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end

    // State Logic (Combinational)
    always_comb begin
        next_state = 3'bxxx; // default undefined state
        case (current_state)
            RED: next_state = YELLOW;
            YELLOW: next_state = GREEN;
            GREEN: next_state = CYAN;
            CYAN: next_state = BLUE;
            BLUE: next_state = MAGENTA;
            MAGENTA: next_state = RED;
            default: next_state = RED;
        endcase
    end

    // Output Register (Sequential)
    always_ff @(posedge clk) begin
        red <= next_red;
        green <= next_green;
        blue <= next_blue;
    end

    // Output Logic (Combinational)
    always_comb begin
        next_red = (current_state == RED) || (current_state == YELLOW) || (current_state == MAGENTA);
        next_green = (current_state == GREEN) || (current_state == YELLOW) || (current_state == CYAN);
        next_blue = (current_state == BLUE) || (current_state == CYAN) || (current_state == MAGENTA);
    end

endmodule