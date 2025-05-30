# Unified-Matrix-Processing-Engine



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

The **Matrix Processing Engine (MPE)** is a core component of the FlightLLM system, designed to accelerate inference for Large Language Models (LLMs) on FPGA hardware. The MPE provides a unified architecture to efficiently handle various matrix operations, including General Matrix Multiplication (GEMM), Sparse Matrix-Matrix Multiplication (SpMM), General Matrix-Vector Multiplication (GEMV), Sparse Matrix-Vector Multiplication (SpMV), and Sampled-Dense-Dense Matrix Multiplication (SDDMM). By leveraging hardware/software co-design, the MPE optimizes computational efficiency for both dense and sparse matrix operations.


## Features

- **Unified Architecture**: Supports multiple matrix operations (GEMM, SpMM, GEMV, SpMV, SDDMM) on a single hardware platform.
- **Sparse Matrix Support**: Efficiently processes sparse matrices using a Configurable Sparse DSP Chain (CSD-Chain).
- **High Performance**: Optimized for FPGA with parallelism, pipelining, and hardware resource utilization.
- **Configurability**: Adjustable parameters for matrix dimensions, sparsity patterns, and hardware resources.
- **Scalability**: Modular design with configurable numbers of Matrix Processing Units (MPUs) and Vector Processing Units (VPUs).

## Project Structure

The repository is organized to ensure clarity and ease of navigation. Below is the structure of the `MPE` project, with descriptions for each directory and key file:


### Directory and File Descriptions

| Directory/File       | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `docs/`              | Contains detailed documentation for understanding and using the MPE.       |
| `src/`               | Houses all Verilog source files, organized by module hierarchy.            |
| `README.md`          | The main project overview, including setup and usage instructions.         |

This structure ensures that all components of the project are well-organized, making it easy for users to find source code, testbenches, documentation, and supporting scripts.

## Prerequisites

To use this project, ensure you have the following tools and hardware:

- **FPGA Development Board**: Compatible with Xilinx FPGAs (e.g., Ultrascale+).
- **Xilinx Vivado Design Suite**: For synthesis, implementation, and simulation (version 2022.1 or later recommended).
- **Verilog Simulator**: Vivado Simulator, ModelSim, or similar.
- **Git**: To clone the repository.
- **Operating System**: Linux (Ubuntu 20.04 or later) or Windows 10/11.

