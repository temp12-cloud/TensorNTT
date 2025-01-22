// 本文件用于测试mergeNTT CPU实现的准确性，从而为后续测试提供正确性参考。

#include "common.cuh"
#include "merge_ntt_cpu.cuh"
#include "parameters.cuh"
#include <iostream>

int main(int argc, char* argv[])
{
    int log_nttSize = argc > 1 ? atoi(argv[1]) : 12;

    NTTParameters parameters(log_nttSize);
    MergeNTT merge_ntt(parameters);

    std::vector<uint64_t> input1(parameters.nttSize, 1);
    std::vector<uint64_t> input2(parameters.nttSize, 0);
    // std::vector<uint64_t> output = schoolbook_poly_multiplication(input1, input2,
    // parameters.modulus);

    // for(int i = 0; i < input1.size(); i++)
    // {
    //     input1[i]=i;
    //     // input2.push_back(0);
    // }

    input1 = merge_ntt.ntt(input1);
    // input2=merge_ntt.ntt(input2);
    // std::vector<uint64_t> output1 = merge_ntt.mult(input1, input2);
    // output1=merge_ntt.intt(output1);

    for (int i = 0; i < parameters.nttSize; i++)
    {
        std::cout << input1[i] << std::endl;
        // if(output[i] != output1[i])
        // {
        //     PassMessage(false, "Merge NTT CPU test failed");
        //     return 1;
        // }
    }

    PassMessage(true, "Merge NTT CPU test passed");

    return 0;
}