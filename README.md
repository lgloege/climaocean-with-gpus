# climaocean-with-gpus

Load modules
```sh
module load Julia/1.12.4-linux-x86_64
module load OpenMPI/5.0.3-GCC-13.3.0-CUDA-12.6.0
```

I ran these commands to setup `Project.toml` and `LocalPreferences.toml`

 1. `julia --project=$PROJECT -e 'using Pkg; Pkg.instantiate()'`
 2.` julia --project=$PROJECT -e 'using Pkg; Pkg.add("MPIPreferences"); Pkg.add("MPI")'`
 3. `julia --project=$PROJECT -e 'using MPIPreferences; MPIPreferences.use_system_binary()'` Tom used `julia --project=$PROJECT -e 'using MPIPreferences; MPIPreferences.use_system_binary(library_names="libmpi",mpiexec="srun", export_prefs=true)'`
 4. all the paths to LocalPreferences.toml
 5. `julia --project=$PROJECT -e 'using Pkg; Pkg.add("OpenMPI_jll")'`
 6. `julia --project=$PROJECT -e 'using Pkg; Pkg.add("CUDA"); using CUDA; CUDA.set_runtime_version!(v"12.6")'`

7. instantiate so "CUDA_compiler_jll" downloads `julia --project=$PROJECT -e 'using Pkg; Pkg.instantiate()'`
8. `julia --project=$PROJECT -e 'using MPI; using CUDA; CUDA.precompile_runtime()'`

