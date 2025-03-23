//-----------------------------------------------------------------------------
// Author: Nguyen Trinh
// Created: March 23, 2025
// Last Updated: March 23, 2025
// Description: Sparse multiplexer for selecting non-zero elements based on a sparse index.
//-----------------------------------------------------------------------------

module Sparse_MUX #(
    parameter DATA_WIDTH = 8
)(
    input wire [DATA_WIDTH-1:0] inputs,
    input wire sparse_index,
    output wire [DATA_WIDTH-1:0] selected_output
);

    // Select input if sparse_index is 1, otherwise output 0
    assign selected_output = sparse_index ? inputs : 0;

endmodule
