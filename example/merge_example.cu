// 本文件用于测试merge_ntt.cu中的准确性，从而为后续测试提供正确性参考。
#include "merge_ntt.cuh"
#include "parameters.cuh"
#include <cstdint>
#include <iostream>

int main(int argc, char* argv[])
{

    int log_nttSize = argc > 1 ? atoi(argv[1]) : 12;
    
    
    NTTParameters parameters(log_nttSize);

    std::vector<uint64_t> input(parameters.nttSize, 1);
    std::vector<uint64_t> output_GPU(parameters.nttSize, 0);
    std::vector<uint64_t> output_CPU(parameters.nttSize, 0);
    std::cout << "log_nttSize: " << parameters.log_nttSize << std::endl;
    std::cout << "nttSize: " << parameters.nttSize << std::endl;
    std::cout << "rootSize: " << parameters.rootSize << std::endl;

    


    uint64_t *d_input, *d_output, *d_unityRootReverseTable, *d_inverseRootUnityReverseTable;
    Modulus* d_modulus;

    cudaMalloc(&d_input, parameters.nttSize * sizeof(uint64_t));
    cudaMalloc(&d_output, parameters.nttSize * sizeof(uint64_t));
    cudaMalloc(&d_unityRootReverseTable, parameters.rootSize * sizeof(uint64_t));
    cudaMalloc(&d_inverseRootUnityReverseTable, parameters.rootSize * sizeof(uint64_t));
    cudaMalloc(&d_modulus, sizeof(Modulus));

    cudaMemcpy(d_input, input.data(), parameters.nttSize * sizeof(uint64_t), cudaMemcpyHostToDevice);
    cudaMemcpy(d_unityRootReverseTable, parameters.unityRootReverseTable.data(), parameters.rootSize * sizeof(uint64_t), cudaMemcpyHostToDevice);
    cudaMemcpy(d_inverseRootUnityReverseTable, parameters.inverseUnityRootReverseTable.data(), parameters.rootSize * sizeof(uint64_t), cudaMemcpyHostToDevice);
    cudaStream_t stream0;
    cudaStreamCreate(&stream0);

    GPU_NTT(d_input, d_output, d_unityRootReverseTable, log_nttSize, parameters.modulus, 1, stream0);

    cudaMemcpy(output_GPU.data(), d_output, parameters.nttSize * sizeof(uint64_t), cudaMemcpyDeviceToHost);

    for (int i = 0; i < parameters.nttSize; i++)
    {
        std::cout << output_GPU[i] << " ";
    
    }
    return 0;
}
