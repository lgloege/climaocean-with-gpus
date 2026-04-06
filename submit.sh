#!/bin/bash
#SBATCH --job-name=oceananigans
#SBATCH --account=pi_me586
#SBATCH --ntasks=2
#SBATCH --partition gpu_devel
#SBATCH --gpus-per-task=1
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu=60G

module purge
module load miniconda/24.9.2
module load Julia/1.12.4-linux-x86_64
module load OpenMPI/5.0.3-GCC-13.3.0-CUDA-12.6.0

#module load Julia/1.10.8-linux-x86_64
#module load OpenMPI/5.0.3-GCC-13.3.0-CUDA-12.6.0

#ml Julia/1.10.8-linux-x86_64 OpenMPI/5.0.3-GCC-13.3.0-CUDA-12.6.0

export JULIA_MPI_HAS_CUDA=true
# UCX is broker to talk between stuff
# turns off warnings to avoid issues
export UCX_WARN_UNUSED_ENV_VARS=n
export UCX_MEMTYPE_CACHE=n
# transpors layer selection. ipc is for nvlink --> connect gpus to each other
# rc is infinaband communication
export UCX_TLS=sm,cuda_copy,cuda_ipc,rc

# this one may not be needed. try removing this one
export UCX_RNDV_SCHEME=put_zcopy

# how open MPI communicates
# pml is part of way communicate through infiniband. point to point messaging layer
# use these messaging layers and not others
# some of these may not be needed?
export OMPI_MCA_pml=ob1
export OMPI_MCA_btl=self,vader,tcp

# routes all MPI traffic through UCX
# i commented out previous two lines
#export OMPI_MCA_pml=ucx

#export JULIA_MPI_HAS_CUDA=true
##export PALS_TRANSFER=false
##export JULIA_CUDA_MEMORY_POOL=none
#export UCX_WARN_UNUSED_ENV_VARS=n
##export UCX_TLS=sm,cuda_copy

# UCX Configuration for CUDA-aware MPI
#export UCX_MEMTYPE_CACHE=n
#export UCX_TLS=sm,cuda_copy,cuda_ipc,rc
#export UCX_RNDV_SCHEME=put_zcopy
#export OMPI_MCA_pml=ob1
#export OMPI_MCA_btl=self,vader,tcp


###---------------------------------------------------------
### if true, this will instantiate the project
### set to true only if the project is not instantiated yet
### this will only need to be done once
###---------------------------------------------------------

INSTANTIATE=false

###---------------------------------------------------------
### path to simulation you want to run
###---------------------------------------------------------

SIMULATION=/home/ljg48/project_pi_me586/ljg48/multi-gpu-test/simulation.jl

###---------------------------------------------------------
### this is path where where Project.toml is
### note: do not put Project.toml at end of the path
###---------------------------------------------------------

PROJECT=/home/ljg48/project_pi_me586/ljg48/multi-gpu-test/

###---------------------------------------------------------
### this is where all downloaded file will live
### will make scratch directory if does not already exist
###---------------------------------------------------------

DEPOT_PATH=/nfs/roberts/scratch/pi_me586/ljg48/julia_depot
export JULIA_DEPOT_PATH=${DEPOT_PATH}

###-------------------------------------------
### this contains ECCO credentials
### your ~/.ecco-credentials 
### should contain only these two lines:
###
### export ECCO_USERNAME=your-username
### export ECCO_PASSWORD=your-password
###-------------------------------------------

source /home/${USER}/.ecco-env 

###-------------------------------------------
### instantiates packages
### should only have to run this once
###-------------------------------------------

if ${INSTANTIATE}; then
    julia --project="${PROJECT}" -e "using Pkg; Pkg.instantiate()"
fi

wait

###-------------------------------------------
### runs the actual simulation
###-------------------------------------------

srun julia --project=${PROJECT} ${SIMULATION}

