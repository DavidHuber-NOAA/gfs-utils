help([[
Build environment for GFS utilities on WCOSS2
]])

prepend_path("MODULEPATH", "/apps/ops/test/spack-stack-1.6.0-nco/envs/nco-intel-19.1.3.304/install/modulefiles/Core")

local stack_intel_ver=os.getenv("stack_intel_ver") or "19.1.3.304"
local stack_impi_ver=os.getenv("stack_cray_mpich_ver") or "8.1.9"
local cmake_ver=os.getenv("cmake_ver") or "3.23.1"

load(pathJoin("stack-intel", stack_intel_ver))
load(pathJoin("stack-cray-mpich", stack_cray_mpich_ver))
load(pathJoin("cmake", cmake_ver))

-- BUFR is a different version on WCOSS2 spack-stack
setenv("bufr_ver", "12.0.1")

load("gfsutils_common")

whatis("Description: GFS utilities environment on WCOSS2 with Intel Compilers")
