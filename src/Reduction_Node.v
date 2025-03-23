//-----------------------------------------------------------------------------
// Author: Nguyen Trinh
// Created: March 23, 2025
// Last Updated: March 23, 2025
// Description: Reduction node for handling sparse operation outputs in the CSD-Chain.
//-----------------------------------------------------------------------------

module Reduction_Node #(
    parameter ACCUM_WIDTH = 48
)(
    input wire [ACCUM_WIDTH-1:0] input_data,
    input wire [ACCUM_WIDTH-1:0] msp,
    input wire sparse_en,
    output wire [ACCUM_WIDTH-1:0] output_data
);

    // For sparse operations, combine LSP and MSP; otherwise, pass through
    assign output_data = sparse_en ? (input_data + msp) : input_data;

endmodule
