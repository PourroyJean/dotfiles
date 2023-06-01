ulimit -c unlimited
ulimit -s unlimited

module load PrgEnv-cray
module load craype-x86-trento
module load craype-accel-amd-gfx90a
module load rocm
export MPICH_GPU_SUPPORT_ENABLED=1
