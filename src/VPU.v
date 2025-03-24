//-----------------------------------------------------------------------------
// Module: VPU (Vector Processing Unit)
// Author: Nguyen Trinh
// Created: March 23, 2025
// Last Updated: March 23, 2025
// Description:
//   The Vector Processing Unit (VPU) computes a dot product of two vectors (one row
//   from matrix A and one column from matrix B). It contains multiple DSP Groups (DGs)
//   connected in a cascade chain to accumulate results. Each VPU processes NUM_DGS * ELEMENTS_PER_DG elements.
// Parameters:
//   - NUM_DGS: Number of DSP Groups in the VPU (default: 16).
//   - ELEMENTS_PER_DG: Number of elements processed by each DSP Group (default: 4).
//   - DATA_WIDTH: Data width of input elements (default: 8 for INT8).
//   - ACCUM_WIDTH: Width of the accumulator (default: 32).
//   - SPARSE_INDEX_WIDTH: Width of the sparse index (default: 1 bit per DSP Group).
// Inputs:
//   - clk: Clock signal.
//   - rst_n: Active-low reset signal.
//   - activation_in: Input vector from matrix A (NUM_DGS * ELEMENTS_PER_DG elements).
//   - weight_in: Input vector from matrix B (NUM_DGS * ELEMENTS_PER_DG elements).
//   - sparse_index: Sparse index for each DSP Group (NUM_DGS bits).
//   - mode: Operation mode (0: MM mode, 1: MV mode; currently supports MM mode).
//   - start: Start signal to initiate computation.
// Outputs:
//   - output_data: Accumulated result (dot product) of the vectors.
//   - done: Done signal indicating computation completion.
// Dependencies:
//   - DSP_Group.v
//-----------------------------------------------------------------------------

module VPU #(
    parameter NUM_DGS = 16,           // Number of DSP Groups (16 DGs for 64 elements)
    parameter ELEMENTS_PER_DG = 4,    // Elements per DSP Group (4 elements per DG)
    parameter DATA_WIDTH = 8,         // Data width (INT8)
    parameter ACCUM_WIDTH = 32,       // Accumulator width
    parameter SPARSE_INDEX_WIDTH = 1  // Sparse index width (1 bit per DG)
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] activation_in [0:NUM_DGS*ELEMENTS_PER_DG-1], // Input vector A
    input wire [DATA_WIDTH-1:0] weight_in [0:NUM_DGS*ELEMENTS_PER_DG-1],     // Input vector B
    input wire [NUM_DGS-1:0] sparse_index,                                   // Sparse index for each DG
    input wire mode,                                                         // Operation mode (MM/MV)
    input wire start,
    output wire [ACCUM_WIDTH-1:0] output_data,                               // Dot product result
    output wire done
);

    // Internal signals for DSP Group outputs and cascade connections
    wire [ACCUM_WIDTH-1:0] dg_output [0:NUM_DGS-1];
    wire [ACCUM_WIDTH-1:0] cascade_in [0:NUM_DGS];
    wire [ACCUM_WIDTH-1:0] cascade_out [0:NUM_DGS-1];
    wire [NUM_DGS-1:0] dg_done;

    // Instantiate DSP Groups
    genvar i;
    generate
        for (i = 0; i < NUM_DGS; i = i + 1) begin : dg_inst
            DSP_Group #(
                .ELEMENTS_PER_DG(ELEMENTS_PER_DG),
                .DATA_WIDTH(DATA_WIDTH),
                .ACCUM_WIDTH(ACCUM_WIDTH),
                .SPARSE_INDEX_WIDTH(SPARSE_INDEX_WIDTH)
            ) dg (
                .clk(clk),
                .rst_n(rst_n),
                .activation_in(activation_in[i*ELEMENTS_PER_DG +: ELEMENTS_PER_DG]), // Slice ELEMENTS_PER_DG elements
                .weight_in(weight_in[i*ELEMENTS_PER_DG +: ELEMENTS_PER_DG]),         // Slice ELEMENTS_PER_DG elements
                .sparse_index(sparse_index[i]),
                .cascade_in(cascade_in[i]),
                .cascade_out(cascade_out[i]),
                .output_data(dg_output[i]),
                .start(start),
                .done(dg_done[i])
            );
        end
    endgenerate

    // Configure cascade path
    assign cascade_in[0] = 0; // First DSP Group has no cascade input
    generate
        for (i = 1; i < NUM_DGS; i = i + 1) begin : cascade_logic
            assign cascade_in[i] = (sparse_index[i-1]) ? 0 : cascade_out[i-1]; // Break cascade if sparse
        end
    endgenerate

    // Output selection: Use last DG for dense operation, or last DG output for sparse
    assign output_data = (sparse_index == 0) ? cascade_out[NUM_DGS-1] : dg_output[NUM_DGS-1];
    assign done = &dg_done; // Done when all DGs are done

endmodule
