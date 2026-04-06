# climaocean-with-gpus

Load modules
```sh
module load Julia/1.12.4-linux-x86_64
module load OpenMPI/5.0.3-GCC-13.3.0-CUDA-12.6.0
```

load envionrment variables
```sh
source ./env
```

run the simulation and save output
```sh
srun julia --project=${PROJECT} ${SIMULATION} 2>&1 | tee -a output.txt
```

## Some useful Julia stuff

Check Cuda version Julia sees
```julia
using CUDA
CUDA.runtime_version()
CUDA.versioninfo()
```


## Some errors I have received

I use h200 because of this error
```sh
julia> CUDA.runtime_version() v"12.6.0" julia> CUDA.device() ┌ Warning: Your NVIDIA RTX PRO 6000 Blackwell Server Edition GPU (compute capability 12.0) is not fully supported by CUDA 12.6.0. │ Some functionality may be broken. Ensure you are using the latest version of CUDA.jl in combination with an up-to-date NVIDIA driver. │ If that does not help, please file an issue to add support for the latest CUDA toolkit. └ @ CUDA /nfs/roberts/scratch/pi_me586/ljg48/julia_depot/packages/CUDA/Il00B/lib/cudadrv/state.jl:230 CuDevice(0): NVIDIA RTX PRO 6000 Blackwell Server Edition
```
## How I setup Project.toml

I ran these commands to setup `Project.toml` and `LocalPreferences.toml`

 1. `julia --project=$PROJECT -e 'using Pkg; Pkg.instantiate()'`
 2.` julia --project=$PROJECT -e 'using Pkg; Pkg.add("MPIPreferences"); Pkg.add("MPI")'`
 3. `julia --project=$PROJECT -e 'using MPIPreferences; MPIPreferences.use_system_binary()'` Tom used `julia --project=$PROJECT -e 'using MPIPreferences; MPIPreferences.use_system_binary(library_names="libmpi",mpiexec="srun", export_prefs=true)'`
 4. all the paths to LocalPreferences.toml
 5. `julia --project=$PROJECT -e 'using Pkg; Pkg.add("OpenMPI_jll")'`
 6. `julia --project=$PROJECT -e 'using Pkg; Pkg.add("CUDA"); using CUDA; CUDA.set_runtime_version!(v"12.6")'`

7. instantiate so "CUDA_compiler_jll" downloads `julia --project=$PROJECT -e 'using Pkg; Pkg.instantiate()'`
8. `julia --project=$PROJECT -e 'using MPI; using CUDA; CUDA.precompile_runtime()'`

