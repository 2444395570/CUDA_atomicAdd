# CUDA_atomicAdd
CUDA_原子操作函数(atomicAdd),原子操作可以帮助解决内存访问上的竞态。
该程序的运行时间，相比之前的简单的在全局内存上直接进行加法操作的程序，它用的时间更长。这是因为使用原子操作后程序具有更大的执行代价。当然，可以通过使用
共享内存来加速这些原子累加操作。
如果线程规模不变，但原子操作的元素数量扩大，则这些同样次数的原子操作会更快地完成。这是因为更广泛的分布范围上的原子操作有利于利用多个执行原子操作的单元，
以及每个原子操作单元上面的竞争性的原子事务也相应减少了。
