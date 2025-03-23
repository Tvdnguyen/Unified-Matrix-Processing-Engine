# Unified-Matrix-Processing-Engine



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

The **Matrix Processing Engine (MPE)** is a core component of the FlightLLM system, designed to accelerate inference for Large Language Models (LLMs) on FPGA hardware. The MPE provides a unified architecture to efficiently handle various matrix operations, including General Matrix Multiplication (GEMM), Sparse Matrix-Matrix Multiplication (SpMM), General Matrix-Vector Multiplication (GEMV), Sparse Matrix-Vector Multiplication (SpMV), and Sampled-Dense-Dense Matrix Multiplication (SDDMM). By leveraging hardware/software co-design, the MPE optimizes computational efficiency for both dense and sparse matrix operations.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Clone the Repository](#1-clone-the-repository)
  - [Run Simulation](#2-run-simulation)
  - [Synthesize and Implement on FPGA](#3-synthesize-and-implement-on-fpga)
  - [Customize Parameters](#4-customize-parameters)
- [Usage](#usage)
- [Documentation](#documentation)
- [Assumptions and Limitations](#assumptions-and-limitations)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgments](#acknowledgments)

## Features

- **Unified Architecture**: Supports multiple matrix operations (GEMM, SpMM, GEMV, SpMV, SDDMM) on a single hardware platform.
- **Sparse Matrix Support**: Efficiently processes sparse matrices using a Configurable Sparse DSP Chain (CSD-Chain).
- **High Performance**: Optimized for FPGA with parallelism, pipelining, and hardware resource utilization.
- **Configurability**: Adjustable parameters for matrix dimensions, sparsity patterns, and hardware resources.
- **Scalability**: Modular design with configurable numbers of Matrix Processing Units (MPUs) and Vector Processing Units (VPUs).

## Project Structure

The repository is organized to ensure clarity and ease of navigation. Below is the structure of the `MPE` project, with descriptions for each directory and key file:

MPE/
├── docs/
│   ├── architecture.md       # Overview of the MPE architecture and design principles
│   ├── usage.md              # Step-by-step guide for setting up and using the MPE
│   └── api.md                # API reference detailing module parameters, inputs, and outputs
├── src/
│   ├── MPE.v                 # Top-level module for the Matrix Processing Engine
│   ├── MPU.v                 # Matrix Processing Unit, managing multiple VPUs
│   ├── VPU.v                 # Vector Processing Unit, implementing the CSD-Chain
│   ├── DSP_Group.v           # DSP Group module for computation with DSP48 cores
│   ├── Sparse_MUX.v          # Sparse multiplexer for selecting non-zero elements
│   ├── Reduction_Node.v      # Reduction node for handling sparse operation outputs
│   └── Overflow_Adjust_Unit.v# Unit for adjusting overflow in DSP accumulations
├── test/
│   ├── tb_MPE.v              # Testbench for the top-level MPE module
│   ├── tb_MPU.v              # Testbench for the MPU module
│   └── ...                   # Additional testbenches for other submodules
├── scripts/
│   └── build.sh              # Shell script for synthesis and simulation with Vivado
├── LICENSE                   # MIT License file for the project
├── CONTRIBUTING.md           # Guidelines for contributing to the project
└── README.md                 # Project overview and setup instructions (this file)
