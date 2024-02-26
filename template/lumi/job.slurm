#!/bin/bash
###################################  GENERAL ########################################
#SBATCH --account project_462000031
#SBATCH --reservation                
#SBATCH --partition standard-g       #LUMI : CPU (small, standard) GPU (small-g, standard-g)

#SBATCH --job-name=TODO
#SBATCH --exclusive
#SBATCH --time=00:60:00
#SBATCH --constraint=                 #for adastra: MI250
#SBATCH --output=job-%j.out
#SBATCH --error=job-%j.err
#####################################################################################


###################################    JOB   ########################################
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:8
##SBATCH --gpus-per-node=1
#SBATCH --hint=multithread
#####################################################################################


###################################    ENV   ########################################
export OMP_PLACES=cores
export OMP_PROC_BIND=true
export OMP_NUM_THREADS=8

export MPICH_OFI_NIC_VERBOSE=2      # Display information pertaining to NIC selection
export MPICH_OFI_NIC_POLICY=GPU     # Select a NIC device that is closest to the GPU

export MPICH_GPU_SUPPORT_ENABLED=1  # MPI operations with buffers on GPU-attached memory region

export MPICH_GPU_IPC_ENABLED=1      # GPU IPC support for intra-node GPU-GPU communication

# export MPICH_MPIIO_HINTS_DISPLAY=1
# export MPICH_MPIIO_STATS=1

source env.sh gpu #TODO : select the required env in this script



#################################    SPECIAL   ######################################

 # MPICH_GPU_IPC_THRESHOLD
 #   - Intra-node GPU-GPU (see man mpi)
 #   - maximum size of shared memory segments used for IPC communications
 #   - default 1024
#  export MPICH_GPU_IPC_THRESHOLD=8192 

# export FI_CXI_DEFAULT_VNI=$(od -vAn -N4 -tu < /dev/urandom)


#####################################################################################




###############################    APPLICATION   ####################################

APP_EXE="./app.exe"
APP_FLAGS="args"

SLURM_FLAGS="./select_gpu.sh -N 1 -n 1 --ntasks-per-node=8 --cpus-per-task=${OMP_NUM_THREADS}"


#### -- ENV CHECK -- ####

# env
# srun -N 1 -n 1 ldd ${APP_EXE}

#### -- EXECUTION -- ####

echo "Will run the following command --> srun ${SLURM_FLAGS} ${APP_EXE} ${APP_FLAGS}"
job_starttime=$(date +%s%N)

srun ${SLURM_FLAGS} ${APP_EXE} ${APP_FLAGS}

job_endtime=$(date +%s%N)
job_runtime=$(echo "scale=9; 1.0*10^(-9)*(${job_endtime}-${job_starttime})" | bc -l)
echo "Job time = ${job_runtime} seconds"
