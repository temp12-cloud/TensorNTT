#!/bin/bash
# 检查是否提供了参数
if [ $# -eq 0 ]; then
    echo "使用: $0 <参数>"
    exit 1
fi

param=$1

# 循环从12到24执行命令
for i in {12..24}
do
    sudo /usr/local/cuda/nsight-compute-2024.3.0/ncu --set full --import-source=yes --export report/ncu${param}-$i bin/tensor_${param}_example $i
done
