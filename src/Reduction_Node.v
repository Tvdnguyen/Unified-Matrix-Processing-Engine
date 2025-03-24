//-----------------------------------------------------------------------------
// Module: Reduction_Node
// Author: Nguyen Trinh
// Created: March 10, 2025
// Last Updated: March 23, 2025
// Description:
//   Reduction Node combines LSP and MSP for sparse operations.
//   If sparse_en = 1, it adds MSP to LSP; otherwise, it passes LSP as the output.
// Parameters:
//   - ACCUM_WIDTH: Width of the accumulator (default: 32).
// Inputs:
//   - input_data: LSP (Least Significant Part) from Overflow Adjust Unit.
//   - msp: MSP (Most Significant Part) from Overflow Adjust Unit.
//   - sparse_en: Sparse enable signal (1 bit).
// Outputs:
//   - output_data: Combined result (LSP + MSP if sparse_en = 1, else LSP).
// Dependencies:
//   - None
//-----------------------------------------------------------------------------

module Reduction_Node #(
    parameter ACCUM_WIDTH = 32
)(
    input wire [ACCUM_WIDTH-1:0] input_data,
    input wire [ACCUM_WIDTH-1:0] msp,
    input wire sparse_en,
    output wire [ACCUM_WIDTH-1:0] output_data
);

    assign output_data = sparse_en ? (input_data + msp) : input_data;

endmodule
