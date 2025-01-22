#include "common.cuh"
#include "modular.cuh"
#include "parameters.cuh"
#include "tensor_ntt.cuh"
#include <cstdint>
#include <cstring>
#include <iostream>
#include <sys/types.h>
#include <vector>


int main(int argc, char* argv[])
{
    CudaDevice(); 
    int log_nttSize = argc > 1 ? atoi(argv[1]) : 10;
    int batchSize = argc > 2 ? atoi(argv[2]) : 1;
    TensorNTTParameters parameters(log_nttSize, 5);
    std::cout << "batchSize: " << batchSize << std::endl;
    std::cout << "log_nttSize: " << parameters.log_nttSize << std::endl;
    std::cout << "nttSize: " << parameters.nttSize << std::endl;
    std::cout << "majorSize: " << parameters.majorSize << std::endl;
    std::cout << "minorSize: " << parameters.minorSize << std::endl;
    std::cout << "modulus: " << parameters.modulus.value << std::endl;

    std::vector<uint64_t> h_input(batchSize * parameters.nttSize, 1);
    std::vector<uint64_t> h_input1(batchSize * parameters.nttSize, 0);
    std::vector<uint64_t> h_output(batchSize * parameters.nttSize, 0);
    uint64_t* d_input;
    uint64_t* d_output;
    uint8_t* d_majorMatrix;
    uint8_t* d_minorMatrix;
    uint64_t* d_factorTable;

    CUDA_CHECK(cudaMalloc((void**)&d_input, h_input.size() * sizeof(uint64_t)));
    CUDA_CHECK(cudaMalloc((void**)&d_output, h_output.size() * sizeof(uint64_t)));
    CUDA_CHECK(cudaMalloc((void**)&d_majorMatrix, parameters.majorMatrix.size() * sizeof(uint8_t)));
    CUDA_CHECK(cudaMalloc((void**)&d_minorMatrix, parameters.minorMatrix.size() * sizeof(uint8_t)));
    CUDA_CHECK(cudaMalloc((void**)&d_factorTable, parameters.factorTable.size() * sizeof(uint64_t)));

    CUDA_CHECK(cudaMemcpy(d_input, h_input.data(), h_input.size() * sizeof(uint64_t), cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_majorMatrix, parameters.majorMatrix.data(), parameters.majorMatrix.size() * sizeof(uint8_t), cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_minorMatrix, parameters.minorMatrix.data(), parameters.minorMatrix.size() * sizeof(uint8_t), cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_factorTable, parameters.factorTable.data(), parameters.factorTable.size() * sizeof(uint64_t), cudaMemcpyHostToDevice));

    GPU_TensorNTT_5(d_input, d_output, d_majorMatrix, d_minorMatrix, d_factorTable, parameters.log_nttSize, parameters.modulus, batchSize, parameters.nttSize);

    CUDA_CHECK(cudaMemcpy(h_output.data(), d_output, h_output.size() * sizeof(uint64_t), cudaMemcpyDeviceToHost));
    for (int i = 0; i < batchSize; i++)
    {
        for (int j = 0; j < 32*4; j++)
        {
            for (int k = 0; k < 32; k++)
            {
                std::cout << h_output[i * parameters.nttSize + j * 32 + k] << " ";
            }
            if (j % 32 == 31)
            {
                std::cout << std::endl;
            }
            std::cout << std::endl;
        }
        std::cout << std::endl;
    }
    return 0;
}
