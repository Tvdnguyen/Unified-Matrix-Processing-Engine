//-----------------------------------------------------------------------------
// Author: Nguyen Trinh
// Created: March 23, 2025
// Last Updated: March 23, 2025
// Description: Unit for adjusting overflow in DSP accumulations by splitting into MSP and LSP.
//-----------------------------------------------------------------------------

module Overflow_Adjust_Unit #(
    parameter ACCUM_WIDTH = 48
)(
    input wire [ACCUM_WIDTH-1:0] input_data,
    output wire [ACCUM_WIDTH-1:0] msp,
    output wire [ACCUM_WIDTH-1:0] lsp
);

    // Split the accumulation into LSP (18 bits) and MSP (remaining bits)
    assign lsp = {{(ACCUM_WIDTH-18){1'b0}}, input_data[17:0]};
    assign msp = {{(18){1'b0}}, input_data[ACCUM_WIDTH-1:18]};

endmodule
