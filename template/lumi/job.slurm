#!/bin/bash
# SLURM Batch Script for High-Performance Computing Job Submission
# environmental settings, and execution parameters tailored 
# for both CPU and optional GPU computing environments.
# Author : Jean Pourroy 2024, HPE

# ======================= General Job Information ============================
#  Job Account, Reservation, and Partition                              
# ============================================================================

#SBATCH --account=                      # Lumi : project_462000031
#SBATCH --reservation=                  # hackathon
#SBATCH --partition=                    # CPU: small, standard | GPU: small-g, standard-g
#SBATCH --job-name=                     # Specify a descriptive job name
#SBATCH --constraint=                   # For adastra: MI250, GENOA
#SBATCH --time=00:60:00                 # Job time limit (HH:MM:SS)
#SBATCH --output=run_%x-%j.out          # Standard output file name-jobid

# ======================= Job Resource Allocation ============================
# Job Configuration : modify only once here for the sbatch AND the srun 
# ============================================================================

#SBATCH --exclusive                 # We don't share nodes with others
#SBATCH --time=00:60:00             # Job time limit (HH:MM:SS)
#SBATCH --output=run_%x-%j.out      # Standard output file
#SBATCH --error=run-%x-%j.err       # Standard error file

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
export OMP_NUM_THREADS=2                #  = 1       | 64    | ${SLURM_CPUS_PER_TASK}
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
#  srun ${SLURM_FLAGS} ${APP_EXE} ${APP_FLAGS}
# ===========================================================================


APP_EXE=""                  # TODO
APP_FLAGS=""                # TODO
BIND_CHECK="./xthi_mpi"     # Or other binding tools such as acheck, hellojobstep...

# SLURM Execution Flags used to launch the srun command
# /!\ EDIT IN THE SBATCH /!\
SLURM_FLAGS=(
    --nodes=$SLURM_JOB_NUM_NODES             
    --ntasks=$SLURM_NTASKS                   
    --cpus-per-task=$SLURM_CPUS_PER_TASK     
    --ntasks-per-node=$SLURM_NTASKS_PER_NODE 
    --hint=$SLURM_HINT                       
    --distribution=$J_DISTRIBUTION           
)
SLURM_FLAGS="${SLURM_FLAGS[@]}"



# ================================= DEBUG ======================================


echo "------------------------------------------------------------------"
echo "SLURM Job Configuration:"
echo "------------------------------------------------------------------"
printf "%-25s %s\n" "Number of Nodes:" "$SLURM_JOB_NUM_NODES"
printf "%-25s %s\n" "Total MPI Tasks:" "$SLURM_NTASKS"
printf "%-25s %s\n" "CPUs per MPI Task:" "$SLURM_CPUS_PER_TASK"
printf "%-25s %s\n" "MPI Tasks per Node:" "$SLURM_NTASKS_PER_NODE"
printf "%-25s %s\n" "Hint:" "$SLURM_HINT"
printf "%-25s %s\n" "GPUs requested (Total):" "$SLURM_GPUS"
printf "%-25s %s\n" "GPUs per Node:" "$SLURM_GPUS_PER_NODE"
printf "%-25s %s\n" "Distribution:" "$J_DISTRIBUTION"
echo "------------------------------------------------------------------"
echo "OpenMP Configuration:"
echo "------------------------------------------------------------------"
printf "%-25s %s\n" "OMP Places:" "$OMP_PLACES"
printf "%-25s %s\n" "OMP Proc Bind:" "$OMP_PROC_BIND"
printf "%-25s %s\n" "OMP Num Threads:" "$OMP_NUM_THREADS"
echo "------------------------------------------------------------------"
echo ""
# echo "------------------------------------------------------------------"
# echo " env and ldd"
# echo "------------------------------------------------------------------"
# # env
# # srun -N 1 -n 1 ldd ${APP_EXE}


# ================================= RUN ======================================

echo "------------------------------------------------------------------"
echo " Job starts "
echo "------------------------------------------------------------------"
echo -e "Final srun command is :"
echo "~"
echo -e "srun ${SLURM_FLAGS} ${APP_EXE} ${APP_FLAGS}"
echo -e "~\n\n"


# Execute the Application
job_starttime=$(date +%s%N)
srun ${SLURM_FLAGS} ${BIND_CHECK}               # We advice to use an app to check the binding before
# srun ${SLURM_FLAGS} ${APP_EXE} ${APP_FLAGS}   # Real app launch
job_endtime=$(date +%s%N)

# Calculate and Report Job Runtime
job_runtime=$(echo "scale=9; (${job_endtime} - ${job_starttime}) / 1000000000" | bc -l)


echo -e "\n--------------------------  END  ---------------------------------"
echo "Job runtime = ${job_runtime} seconds"
echo "End of $SLURM_JOB_NAME ($SLURM_JOB_ID) the $(date)"
echo -e "------------------------------------------------------------------\n"