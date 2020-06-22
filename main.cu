#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <memory>

#define NUM_THREADS 10000
#define SIZE 10
#define BLOCK_WIDTH 100

__global__ void gpu_increment_atomic(int* d_a) {
	//�����̵߳�����
	int tid = blockIdx.x * blockDim.x + threadIdx.x;

	//��10��Ԫ����ÿ���߳�����
	tid = tid % SIZE;
	//d_a[tid] += 1;
	atomicAdd(&d_a[tid], 1);    
	/*atomicAddԭ�Ӳ��������滻��֮ǰ��ֱ��+=�������ú�������2����������һ������������Ҫ����ԭ�Ӽӷ�����
	���ڴ����򣻵ڶ��������Ǹ�ԭ�Ӽӷ���������Ҫ���ϵ�ֵ��
	�ú�������߼��ϱ�֤��ÿ�����������̶߳���ͬ���ڴ������ϵġ���ȡ��ֵ-�ۼ�-��д��ֵ�������ǲ��ɱ�
	�����߳����ҵ�ԭ���Ե�������ɵġ�*/
}

int main(void) {
	printf("%d total threads in %d blocks writing into %d array elements\n", NUM_THREADS, NUM_THREADS / BLOCK_WIDTH, SIZE);

	//�����ͷ��������ڴ�
	int h_a[SIZE];
	const int ARRAY_BYTES = SIZE * sizeof(int);

	//�����ͷ���GPU�ڴ�
	int* d_a;
	cudaMalloc((void**)&d_a, ARRAY_BYTES);
	//��ʼ��GPU�ڴ棬Ĭ��ֵΪ0
	cudaMemset((void*)d_a, 0, ARRAY_BYTES);
	gpu_increment_atomic << <NUM_THREADS / BLOCK_WIDTH, BLOCK_WIDTH >> > (d_a);

	//��GPU���ƻ��������Ҵ�ӡ����
	cudaMemcpy(h_a, d_a, ARRAY_BYTES, cudaMemcpyDeviceToHost);
	printf("Number of times a particular Array index has been incremented is:\n");
	for (int i = 0; i < SIZE; i++)
	{
		printf("index:%d --> %d times\n", i, h_a[i]);
	}
	cudaFree(d_a);
	return 0;
}

