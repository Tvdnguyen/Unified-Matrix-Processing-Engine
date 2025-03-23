//-----------------------------------------------------------------------------
// Author: Nguyen Trinh
// Created: March 23, 2025
// Last Updated: March 23, 2025
// Description: Top-level module of the Matrix Processing Engine (MPE).
//              Integrates buffers and MPUs to handle matrix operations like GEMM, SpMM, GEMV, SpMV, and SDDMM.
//-----------------------------------------------------------------------------
// Parameters:
//   - NUM_MPUS: Number of Matrix Processing Units.
//   - DATA_WIDTH: Bit width of activations and weights.
//   - ACCUM_WIDTH: Bit width of accumulators.
//   - BUFFER_DEPTH: Depth of the input/output buffers.
// Inputs:
//   - clk: Clock signal.
//   - rst_n: Active-low reset signal.
//   - activation_in: Input activations.
//   - weight_in: Input weights.
//   - mode: Operation mode (0: MM mode, 1: MV mode).
//   - start: Start signal for the operation.
// Outputs:
//   - activation_out: Output activations.
//   - done: Signal indicating operation completion.
// Assumptions:
//   - Buffers (Activation, Weight, Global) are placeholders and should be implemented using BRAM or external memory.
//   - MPUs operate in parallel to process matrix operations.
