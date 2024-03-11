#!/bin/bash
# SLURM Batch Script for High-Performance Computing Job Submission
# environmental settings, and execution parameters tailored for both CPU and optional GPU computing environments.
# Author : Jean Pourroy 2024, HPE

# ======================= General Job Information ============================
#  Job Account, Reservation, and Partition                              
# ============================================================================

#SBATCH --account=                  # Lumi : project_462000031
#SBATCH --reservation=              # hackathon
#SBATCH --partition=                # CPU: small, standard | GPU: small-g, standard-g
#SBATCH --job-name=                 # Specify a descriptive job name
#SBATCH --constraint=               # For adastra: MI250, GENOA


# ======================= Job Resource Allocation ============================
#  Node, Task, and CPU Configuration                                      
# ============================================================================

#SBATCH --exclusive
#SBATCH --time=00:60:00             # Job time limit (HH:MM:SS)
#SBATCH --output=run-%j.out         # Standard output file
#SBATCH --error=run-%j.err          # Standard error file

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --cpus-per-task=8
#SBATCH --hint=nomultithread

# GPU Configuration (Uncomment if needed)
##SBATCH --gres=gpu:8
##SBATCH --gpus-per-node=1

# SLURM Execution Flags used to launch the srun command
SLURM_FLAGS=(
    --nodes=1                             # or -N : number of nodes
    --ntasks=24                           # or -n : number of MPI tasks
    --cpus-per-task="${OMP_NUM_THREADS}"  # or -c : number of CPUs per MPI task, care hypertread
    --ntasks-per-node=24                  # maximum count of tasks per node
    --hint=nomultithread                  # disable multithread, has to be in both srun/sbatch
    # --distribution=block:block          # node and mpi tasks binding
    # --gpus-per-node=8                   # number of GPUs required per allocated node
    # --ntasks-per-socket=16              # mpi task limit per socket


)
SLURM_FLAGS="${SLURM_FLAGS[@]}"

# ======================= Environment Configuration ==========================
#  OpenMP and module environment
# ============================================================================

export OMP_PLACES=sockets               #  = threads | cores | sockets (corresponds to NUMA)
export OMP_PROC_BIND=true               #  = true    | close | spread | master | false
export OMP_NUM_THREADS=8                #  = 1       | 64    | ${SLURM_CPUS_PER_TASK}

#source env.sh gpu                      # TODO: Select the required environment in this script

# ========================= Special Configuration ============================

# Advanced MPI and GPU Settings (Uncomment if needed)
#export MPICH_OFI_NIC_VERBOSE=2         # Display NIC selection info
#export MPICH_OFI_NIC_POLICY=GPU        # Select NIC closest to GPU
#export MPICH_GPU_SUPPORT_ENABLED=1     # Enable MPI operations on GPU-attached memory
#export MPICH_GPU_IPC_ENABLED=1         # Enable GPU IPC for intra-node communication
#export MPICH_MPIIO_HINTS_DISPLAY=1
#export MPICH_MPIIO_STATS=1

# Environment Script (Uncomment and specify if needed)
# GPU IPC Threshold Adjustment (Uncomment if needed)
#export MPICH_GPU_IPC_THRESHOLD=8192    # Adjust for intra-node GPU-GPU communication

# Random VNI Selection for Fabric Interfaces (Uncomment if needed)
#export FI_CXI_DEFAULT_VNI=$(od -vAn -N4 -tu < /dev/urandom)



# ============================ Job Execution ================================
#  Setup and srun
# ===========================================================================


APP_EXE="./app"   # TODO
APP_FLAGS="--arg" # TODO


# ================================= RUN ======================================

# Optional: Check Environment and Dependencies
# env
# srun -N 1 -n 1 ldd ${APP_EXE}

# Job Execution Command
echo -e "Will run the following command:\n srun ${SLURM_FLAGS} ${APP_EXE} ${APP_FLAGS}\n"
job_starttime=$(date +%s%N)

# Execute the Application
srun ${SLURM_FLAGS} ${APP_EXE} ${APP_FLAGS}

# Calculate and Report Job Runtime
job_endtime=$(date +%s%N)
job_runtime=$(echo "scale=9; (${job_endtime}-${job_starttime})*1e-9" | bc -l)
echo "Job runtime = ${job_runtime} seconds"
