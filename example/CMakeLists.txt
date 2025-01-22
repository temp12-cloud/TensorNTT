
add_executable(merge_ntt_cpu_example merge_ntt_cpu_example.cu)
target_link_libraries(merge_ntt_cpu_example PRIVATE merge_ntt  )
set_target_properties(merge_ntt_cpu_example PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)

add_executable(merge_example merge_example.cu)
target_link_libraries(merge_example PRIVATE merge_ntt  )


# add_executable(tensor_0_example tensor_0_example.cu)
# target_link_libraries(tensor_0_example PRIVATE tensor_ntt  )

# add_executable(tensor_1_example tensor_1_example.cu)
# target_link_libraries(tensor_1_example PRIVATE tensor_ntt  )

# add_executable(tensor_2_example tensor_2_example.cu)
# target_link_libraries(tensor_2_example PRIVATE tensor_ntt  )

# add_executable(tensor_3_example tensor_3_example.cu)
# target_link_libraries(tensor_3_example PRIVATE tensor_ntt  )

# add_executable(tensor_4_example tensor_4_example.cu)
# target_link_libraries(tensor_4_example PRIVATE tensor_ntt  )

# add_executable(tensor_5_example tensor_5_example.cu)
# target_link_libraries(tensor_5_example PRIVATE tensor_ntt  )

# add_executable(tensor_6_example tensor_6_example.cu)
# target_link_libraries(tensor_6_example PRIVATE tensor_ntt  )

add_executable(tensor_7_example tensor_7_example.cu)
target_link_libraries(tensor_7_example PRIVATE tensor_ntt  )

# add_executable(tensor_8_example tensor_8_example.cu)
# target_link_libraries(tensor_8_example PRIVATE tensor_ntt  )

# add_executable(test test.cu)
# target_link_libraries(test PRIVATE tensor_ntt  )
# set_target_properties(test PROPERTIES
#                 CUDA_SEPARABLE_COMPILATION ON)