//-----------------------------------------------------------------------------
// Author: Nguyen Trinh
// Created: March 23, 2025
// Last Updated: March 23, 2025
// Description: DSP Group module, containing DSP48 cores for computation, with sparse MUX, reduction node, and overflow adjust unit.
//-----------------------------------------------------------------------------

module DSP_Group #(
    parameter DATA_WIDTH = 8,
    parameter ACCUM_WIDTH = 48,
    parameter SPARSE_INDEX_WIDTH = 1
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] activation_in,
    input wire [DATA_WIDTH-1:0] weight_in,
    input wire [SPARSE_INDEX_WIDTH-1:0] sparse_index,
    input wire [ACCUM_WIDTH-1:0] cascade_in,
    output wire [ACCUM_WIDTH-1:0] cascade_out,
    output wire [ACCUM_WIDTH-1:0] output_data,
    input wire start,
    output wire done
);

    // Internal signals
    wire [DATA_WIDTH-1:0] selected_activation;
    wire [ACCUM_WIDTH-1:0] dsp_result;
    wire [ACCUM_WIDTH-1:0] msp, lsp;

    // Sparse MUX: Selects non-zero elements based on sparse_index
    Sparse_MUX #(
        .DATA_WIDTH(DATA_WIDTH)
    ) sparse_mux (
        .inputs(activation_in),
        .sparse_index(sparse_index),
        .selected_output(selected_activation)
    );

    // DSP48 simulation: Performs two INT8 MACs (simplified as one for clarity)
    reg [ACCUM_WIDTH-1:0] accum;
    wire [15:0] prod = selected_activation * weight_in;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accum <= 0;
        end else if (start) begin
            accum <= cascade_in + prod;
        end
    end

    // Overflow Adjust Unit: Splits accumulation to prevent overflow
    Overflow_Adjust_Unit #(
        .ACCUM_WIDTH(ACCUM_WIDTH)
    ) oau (
        .input_data(accum),
        .msp(msp),
        .lsp(lsp)
    );

    // Reduction Node: Handles sparse operation outputs
    Reduction_Node #(
        .ACCUM_WIDTH(ACCUM_WIDTH)
    ) rn (
        .input_data(lsp),
        .msp(msp),
        .output_data(output_data),
        .sparse_en(sparse_index)
    );

    // Cascade output to the next DSP Group
    assign cascade_out = lsp;
    assign done = start;

endmodule
