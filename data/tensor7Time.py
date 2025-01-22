# tensor 5
import subprocess
import pandas as pd

# 初始化一个空的DataFrame
df = pd.DataFrame(columns=["规模", "H100 us", "A100 us", "4090 us"])

# 可执行程序的路径
program_name = "./bin/tensor_7_time"

batchSize =1
# 遍历 log_nttSize 参数从4到16
for log_nttSize in range(12, 25):
    command = [program_name, str(log_nttSize),str(batchSize)]  # 将 log_nttSize 转换为字符串
    # 调用程序并捕获输出
    result = subprocess.run(command, capture_output=True, text=True)
    
    # 解析程序的输出
    output_lines = result.stdout.splitlines()
    
    gpu_type = None
    gpu_time = None
    
    for line in output_lines:
        if "GPU Device" in line:
            # 获取 GPU 型号
            if "H100" in line:
                gpu_type = "H100 us"
            elif "A100" in line:
                gpu_type = "A100 us"
            elif "4090" in line:
                gpu_type = "4090 us"
        elif "time:" in line:
            # 获取 GPU_NTT time 值
            gpu_time = float(line.split(":")[1].strip().split()[0])
    
    # 初始化 row 字典并填充数据
    row = {"规模": log_nttSize, "H100 us": None, "A100 us": None, "4090 us": None}
    
    if gpu_type and gpu_time is not None:
        row[gpu_type] = round(gpu_time, 5)
    
    # 输出解析后的行，用于调试
    print(row)

    # 将这一行数据添加到DataFrame中
    new_row_df = pd.DataFrame([row])
    
    # 检查 new_row_df 是否为空，或者所有值是否都是 NA（严格检查每一列）
    if not new_row_df.isna().all(axis=None):
        df = pd.concat([df, new_row_df], ignore_index=True)

# 将DataFrame写入Excel文件
output_path = "./data/tensor7time.xlsx"
df.to_excel(output_path, index=False)

print("执行完毕")
