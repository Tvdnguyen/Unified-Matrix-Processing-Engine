//-----------------------------------------------------------------------------
// Module: DSP_Group
// Author: Nguyen Trinh
// Created: March 10, 2025
// Last Updated: March 23, 2025
// Description:
//   The DSP Group module processes ELEMENTS_PER_DG elements in parallel, performing
//   multiply-accumulate (MAC) operations. It simulates DSP48 slices (e.g., 2 DSP48 for 4 elements).
//   Supports sparse operations with Sparse MUX, Overflow Adjust Unit, and Reduction Node.
// Parameters:
//   - ELEMENTS_PER_DG: Number of elements processed by this DSP Group (default: 4).
//   - DATA_WIDTH: Data width of input elements (default: 8 for INT8).
//   - ACCUM_WIDTH: Width of the accumulator (default: 32).
//   - SPARSE_INDEX_WIDTH: Width of the sparse index (default: 1 bit).
// Inputs:
//   - clk: Clock signal.
//   - rst_n: Active-low reset signal.
//   - activation_in: Input elements from matrix A (ELEMENTS_PER_DG elements).
//   - weight_in: Input elements from matrix B (ELEMENTS_PER_DG elements).
//   - sparse_index: Sparse index to control skipping of zero elements.
//   - cascade_in: Cascade input from previous DSP Group.
//   - start: Start signal to initiate computation.
// Outputs:
//   - cascade_out: Cascade output to next DSP Group.
//   - output_data: Output data after reduction.
//   - done: Done signal indicating computation completion.
// Dependencies:
//   - Sparse_MUX.v
//   - Overflow_Adjust_Unit.v
//   - Reduction_Node.v
//-----------------------------------------------------------------------------

module DSP_Group #(
    parameter ELEMENTS_PER_DG = 4,    // Number of elements per DSP Group
    parameter DATA_WIDTH = 8,         // Data width (INT8)
    parameter ACCUM_WIDTH = 32,       // Accumulator width
    parameter SPARSE_INDEX_WIDTH = 1  // Sparse index width
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] activation_in [0:ELEMENTS_PER_DG-1], // Activation inputs
    input wire [DATA_WIDTH-1:0] weight_in [0:ELEMENTS_PER_DG-1],     // Weight inputs
    input wire [SPARSE_INDEX_WIDTH-1:0] sparse_index,
    input wire [ACCUM_WIDTH-1:0] cascade_in,
    output wire [ACCUM_WIDTH-1:0] cascade_out,
    output wire [ACCUM_WIDTH-1:0] output_data,
    input wire start,
    output wire done
);

    // Internal signals
    wire [DATA_WIDTH-1:0] selected_activation [0:ELEMENTS_PER_DG-1];
    wire [15:0] products [0:ELEMENTS_PER_DG-1]; // INT8 x INT8 = 16-bit
    wire [ACCUM_WIDTH-1:0] msp, lsp;

    // Sparse MUX for each element
    genvar i;
    generate
        for (i = 0; i < ELEMENTS_PER_DG; i = i + 1) begin : sparse_mux_inst
            Sparse_MUX #(
                .DATA_WIDTH(DATA_WIDTH)
            ) sparse_mux (
                .inputs(activation_in[i]),
                .sparse_index(sparse_index),
                .selected_output(selected_activation[i])
            );
        end
    endgenerate

    // Compute products (INT8 x INT8)
    generate
        for (i = 0; i < ELEMENTS_PER_DG; i = i + 1) begin : product_compute
            assign products[i] = selected_activation[i] * weight_in[i];
        end
    endgenerate

    // Accumulate products (simulating DSP48 cores)
    reg [ACCUM_WIDTH-1:0] accum;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accum <= 0;
        end else if (start) begin
            accum <= cascade_in + $signed(products[0]) + $signed(products[1]) + 
                     $signed(products[2]) + $signed(products[3]); // Accumulate ELEMENTS_PER_DG products
        end
    end

    // Overflow Adjust Unit
    Overflow_Adjust_Unit #(
        .ACCUM_WIDTH(ACCUM_WIDTH)
    ) oau (
        .input_data(accum),
        .msp(msp),
        .lsp(lsp)
    );

    // Reduction Node
    Reduction_Node #(
        .ACCUM_WIDTH(ACCUM_WIDTH)
    ) rn (
        .input_data(lsp),
        .msp(msp),
        .output_data(output_data),
        .sparse_en(sparse_index)
    );

    // Cascade output
    assign cascade_out = lsp;
    assign done = start; // Simplified: Done after one cycle (can be pipelined)

endmodule
