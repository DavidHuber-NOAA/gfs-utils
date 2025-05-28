help([[
Build environment for GFS utilities on Hera
]])

prepend_path("MODULEPATH", "/contrib/spack-stack/spack-stack-1.6.0/envs/gsi-addon-dev-rocky8/install/modulefiles/Core")

--Spack-stack root path and environment name
stack_root=os.getenv("stack_root") or "/contrib/spack-stack"
stack_env=os.getenv("stack_env") or "ue-intel-" .. stack_intel_ver

--Stack compiler and MPI modules to load
stack_compiler=os.getenv("stack_compiler") or pathJoin("stack-intel", stack_intel_ver)
stack_mpi=os.getenv("stack_mpi") or pathJoin("stack-intel-oneapi-mpi", stack_impi_ver)

load("gfsutils_common")

whatis("Description: GFS utilities environment on Hera with Intel Compilers")
