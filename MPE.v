//-----------------------------------------------------------------------------
// Author: Nguyen Trinh
// Created: March 23, 2025
// Last Updated: March 23, 2025
// Description: Top-level module of the Matrix Processing Engine (MPE).
//              Integrates buffers and MPUs to handle matrix operations like GEMM, SpMM, GEMV, SpMV, and SDDMM.
//-----------------------------------------------------------------------------
// Parameters:
//   - NUM_MPUS: Number of Matrix Processing Units.
//   - DATA_WIDTH: Bit width of activations and weights.
//   - ACCUM_WIDTH: Bit width of accumulators.
//   - BUFFER_DEPTH: Depth of the input/output buffers.
// Inputs:
//   - clk: Clock signal.
//   - rst_n: Active-low reset signal.
//   - activation_in: Input activations.
//   - weight_in: Input weights.
//   - mode: Operation mode (0: MM mode, 1: MV mode).
//   - start: Start signal for the operation.
// Outputs:
//   - activation_out: Output activations.
//   - done: Signal indicating operation completion.
// Assumptions:
//   - Buffers (Activation, Weight, Global) are placeholders and should be implemented using BRAM or external memory.
//   - MPUs operate in parallel to process matrix operations.

module MPE #(
    parameter NUM_MPUS = 4,
    parameter DATA_WIDTH = 8,
    parameter ACCUM_WIDTH = 48,
    parameter BUFFER_DEPTH = 1024
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] activation_in,
    input wire [DATA_WIDTH-1:0] weight_in,
    input wire mode,
    input wire start,
    output wire [DATA_WIDTH-1:0] activation_out,
    output wire done
);

    // Internal signals for connecting MPUs and buffers
    wire [DATA_WIDTH-1:0] activation_data [0:NUM_MPUS-1];
    wire [DATA_WIDTH-1:0] weight_data [0:NUM_MPUS-1];
    wire [DATA_WIDTH-1:0] mpu_output [0:NUM_MPUS-1];
    wire [NUM_MPUS-1:0] mpu_done;

    // Placeholder for Activation Buffer (to be implemented with BRAM)
    // Streams activation data to MPUs
    reg [DATA_WIDTH-1:0] activation_buffer [0:BUFFER_DEPTH-1];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            integer i;
            for (i = 0; i < NUM_MPUS; i = i + 1) begin
                activation_data[i] <= 0;
            end
        end else if (start) begin
            integer j;
            for (j = 0; j < NUM_MPUS; j = j + 1) begin
                activation_data[j] <= activation_in; // Simplified streaming
            end
        end
    end

    // Placeholder for Weight Buffer (to be implemented with BRAM)
    // Streams weight data to MPUs
    reg [DATA_WIDTH-1:0] weight_buffer [0:BUFFER_DEPTH-1];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            integer i;
            for (i = 0; i < NUM_MPUS; i = i + 1) begin
                weight_data[i] <= 0;
            end
        end else if (start) begin
            integer j;
            for (j = 0; j < NUM_MPUS; j = j + 1) begin
                weight_data[j] <= weight_in; // Simplified streaming
            end
        end
    end

    // Placeholder for Global Buffer (to be implemented with BRAM)
    // Stores output activations
    reg [DATA_WIDTH-1:0] global_buffer [0:BUFFER_DEPTH-1];
    assign activation_out = mpu_output[0]; // Simplified: takes output from first MPU

    // Instantiate MPUs
    genvar i;
    generate
        for (i = 0; i < NUM_MPUS; i = i + 1) begin : mpu_inst
            MPU #(
                .DATA_WIDTH(DATA_WIDTH),
                .ACCUM_WIDTH(ACCUM_WIDTH)
            ) mpu (
                .clk(clk),
                .rst_n(rst_n),
                .activation_in(activation_data[i]),
                .weight_in(weight_data[i]),
                .mode(mode),
                .start(start),
                .output_data(mpu_output[i]),
                .done(mpu_done[i])
            );
        end
    endgenerate

    // Combine MPU done signals to indicate overall completion
    assign done = &mpu_done;

endmodule
