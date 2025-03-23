# Unified-Matrix-Processing-Engine



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Issues](https://img.shields.io/github/issues/yourusername/FlightLLM-MPE)](https://github.com/yourusername/FlightLLM-MPE/issues)
[![GitHub Stars](https://img.shields.io/github/stars/yourusername/FlightLLM-MPE)](https://github.com/yourusername/FlightLLM-MPE/stargazers)

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
