module memory #(
    parameter INIT_FILE = ""
)(
    input logic     clk,
    input logic     [6:0] read_address,
    output logic    [9:0] read_data
);

    // Declare memory array for storing 128 10-bit samples of a sine function
    logic [9:0] sample_memory [0:127];
    logic [1:0] quadrant = 0; // Variable to control sine wave quadrant

    initial if (INIT_FILE) begin // Start to read the memory file
        $readmemh(INIT_FILE, sample_memory);
    end

    // Update quadrant on read_address overflow
    always_ff @(posedge clk) begin
        if (read_address == 127) begin
            quadrant <= quadrant + 1;
        end
    end

    // Read data from memory based on quadrant
    always_ff @(posedge clk) begin
        case (quadrant)
            2'b00: read_data <= sample_memory[read_address]; // 0 - 90 degrees
            2'b01: read_data <= sample_memory[127 - read_address]; // 90 - 180 degrees
            2'b10: read_data <= ~sample_memory[read_address] + 1'b1; // 180 - 270 degrees
            2'b11: read_data <= ~sample_memory[127 - read_address] + 1'b1; // 270 - 360 degrees
        endcase
    end

endmodule