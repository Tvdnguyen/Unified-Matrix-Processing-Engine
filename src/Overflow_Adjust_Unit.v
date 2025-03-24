//-----------------------------------------------------------------------------
// Module: Overflow_Adjust_Unit
// Author: Nguyen Trinh
// Created: March 10, 2025
// Last Updated: March 23, 2025
// Description:
//   Overflow Adjust Unit splits the accumulated result into MSP (Most Significant Part)
//   and LSP (Least Significant Part) to prevent overflow in the cascade chain.
// Parameters:
//   - ACCUM_WIDTH: Width of the accumulator (default: 32).
// Inputs:
//   - input_data: Accumulated result to be split.
// Outputs:
//   - msp: Most Significant Part (upper bits).
//   - lsp: Least Significant Part (lower bits).
// Dependencies:
//   - None
//-----------------------------------------------------------------------------

module Overflow_Adjust_Unit #(
    parameter ACCUM_WIDTH = 32
)(
    input wire [ACCUM_WIDTH-1:0] input_data,
    output wire [ACCUM_WIDTH-1:0] msp,
    output wire [ACCUM_WIDTH-1:0] lsp
);

    // Split at half of ACCUM_WIDTH for INT8 (16 bits for INT8 x INT8 product)
    localparam SPLIT_POINT = ACCUM_WIDTH / 2;
    assign lsp = {{(ACCUM_WIDTH-SPLIT_POINT){1'b0}}, input_data[SPLIT_POINT-1:0]}; // Lower half
    assign msp = {{(SPLIT_POINT){1'b0}}, input_data[ACCUM_WIDTH-1:SPLIT_POINT]};   // Upper half

endmodule
