#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <memory>

#define NUM_THREADS 10000
#define SIZE 10
#define BLOCK_WIDTH 100

__global__ void gpu_increment_atomic(int* d_a) {
	//计算线程的索引
	int tid = blockIdx.x * blockDim.x + threadIdx.x;

	//在10个元素中每个线程增加
	tid = tid % SIZE;
	//d_a[tid] += 1;
	atomicAdd(&d_a[tid], 1);    
	/*atomicAdd原子操作函数替换了之前的直接+=操作，该函数具有2个参数：第一个参数是我们要进行原子加法操作
	的内存区域；第二个参数是该原子加法操作具体要加上的值。
	该函数会从逻辑上保证，每个调用它的线程对相同的内存区域上的“读取旧值-累加-回写新值”操作是不可被
	其他线程扰乱的原子性的整体完成的。*/
}

int main(void) {
	printf("%d total threads in %d blocks writing into %d array elements\n", NUM_THREADS, NUM_THREADS / BLOCK_WIDTH, SIZE);

	//声明和分配主机内存
	int h_a[SIZE];
	const int ARRAY_BYTES = SIZE * sizeof(int);

	//声明和分配GPU内存
	int* d_a;
	cudaMalloc((void**)&d_a, ARRAY_BYTES);
	//初始化GPU内存，默认值为0
	cudaMemset((void*)d_a, 0, ARRAY_BYTES);
	gpu_increment_atomic << <NUM_THREADS / BLOCK_WIDTH, BLOCK_WIDTH >> > (d_a);

	//从GPU复制回主机并且打印出来
	cudaMemcpy(h_a, d_a, ARRAY_BYTES, cudaMemcpyDeviceToHost);
	printf("Number of times a particular Array index has been incremented is:\n");
	for (int i = 0; i < SIZE; i++)
	{
		printf("index:%d --> %d times\n", i, h_a[i]);
	}
	cudaFree(d_a);
	return 0;
}

