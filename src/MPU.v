//-----------------------------------------------------------------------------
// Author: Nguyen Trinh
// Created: March 23, 2025
// Last Updated: March 23, 2025
// Description: Matrix Processing Unit, managing multiple VPUs to perform matrix operations.
//-----------------------------------------------------------------------------

module MPU #(
    parameter NUM_VPUS = 4,
    parameter DATA_WIDTH = 8,
    parameter ACCUM_WIDTH = 48,
    parameter SPARSE_INDEX_WIDTH = 4
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] activation_in,
    input wire [DATA_WIDTH-1:0] weight_in,
    input wire mode,
    input wire start,
    input wire [SPARSE_INDEX_WIDTH-1:0] sparse_index,
    output wire [DATA_WIDTH-1:0] output_data,
    output wire done
);

    // Internal signals for VPU outputs and done signals
    wire [ACCUM_WIDTH-1:0] vpu_output [0:NUM_VPUS-1];
    wire [NUM_VPUS-1:0] vpu_done;

    // Instantiate VPUs
    genvar i;
    generate
        for (i = 0; i < NUM_VPUS; i = i + 1) begin : vpu_inst
            VPU #(
                .DATA_WIDTH(DATA_WIDTH),
                .ACCUM_WIDTH(ACCUM_WIDTH),
                .SPARSE_INDEX_WIDTH(SPARSE_INDEX_WIDTH)
            ) vpu (
                .clk(clk),
                .rst_n(rst_n),
                .activation_in(activation_in),
                .weight_in(weight_in),
                .sparse_index(sparse_index),
                .mode(mode),
                .start(start),
                .output_data(vpu_output[i]),
                .done(vpu_done[i])
            );
        end
    endgenerate

    // Reduction logic: Sum VPU outputs for MM mode
    reg [ACCUM_WIDTH-1:0] reduced_output;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reduced_output <= 0;
        end else if (start) begin
            reduced_output <= vpu_output[0] + vpu_output[1] + vpu_output[2] + vpu_output[3];
        end
    end

    // Truncate the accumulated result to DATA_WIDTH for output
    assign output_data = reduced_output[DATA_WIDTH-1:0];
    assign done = &vpu_done;

endmodule
