//-----------------------------------------------------------------------------
// Author: Nguyen Trinh
// Created: March 23, 2025
// Last Updated: March 23, 2025
// Description: Vector Processing Unit, implementing the Configurable Sparse DSP Chain (CSD-Chain).
//-----------------------------------------------------------------------------

module VPU #(
    parameter NUM_DGS = 4,
    parameter DATA_WIDTH = 8,
    parameter ACCUM_WIDTH = 48,
    parameter SPARSE_INDEX_WIDTH = 4
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] activation_in,
    input wire [DATA_WIDTH-1:0] weight_in,
    input wire [SPARSE_INDEX_WIDTH-1:0] sparse_index,
    input wire mode,
    input wire start,
    output wire [ACCUM_WIDTH-1:0] output_data,
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
                .DATA_WIDTH(DATA_WIDTH),
                .ACCUM_WIDTH(ACCUM_WIDTH),
                .SPARSE_INDEX_WIDTH(SPARSE_INDEX_WIDTH)
            ) dg (
                .clk(clk),
                .rst_n(rst_n),
                .activation_in(activation_in),
                .weight_in(weight_in),
                .sparse_index(sparse_index[i]),
                .cascade_in(cascade_in[i]),
                .cascade_out(cascade_out[i]),
                .output_data(dg_output[i]),
                .start(start),
                .done(dg_done[i])
            );
        end
    endgenerate

    // Configure cascade path: Break if sparse_index indicates sparsity
    assign cascade_in[0] = 0;
    generate
        for (i = 1; i < NUM_DGS; i = i + 1) begin : cascade_logic
            assign cascade_in[i] = (sparse_index[i-1]) ? 0 : cascade_out[i-1];
        end
    endgenerate

    // Output selection: Use last DG for dense, configurable for sparse
    assign output_data = (sparse_index == 0) ? cascade_out[NUM_DGS-1] : dg_output[NUM_DGS-1];
    assign done = &dg_done;

endmodule
