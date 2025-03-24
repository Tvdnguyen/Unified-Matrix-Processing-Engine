//-----------------------------------------------------------------------------
// Module: Sparse_MUX
// Author: Nguyen Trinh
// Created: March 10, 2025
// Last Updated: March 23, 2025
// Description:
//   Sparse Multiplexer selects input data based on sparse_index.
//   If sparse_index = 1, pass the input; otherwise, output 0 to skip zero elements.
// Parameters:
//   - DATA_WIDTH: Data width of input elements (default: 8 for INT8).
// Inputs:
//   - inputs: Input data element.
//   - sparse_index: Sparse control signal (1 bit).
// Outputs:
//   - selected_output: Selected output (same as input if sparse_index = 1, else 0).
// Dependencies:
//   - None
//-----------------------------------------------------------------------------

module Sparse_MUX #(
    parameter DATA_WIDTH = 8
)(
    input wire [DATA_WIDTH-1:0] inputs,
    input wire sparse_index,
    output wire [DATA_WIDTH-1:0] selected_output
);

    assign selected_output = sparse_index ? inputs : 0;

endmodule
