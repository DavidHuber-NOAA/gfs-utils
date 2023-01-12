help([[
Build environment for GFS utilities on GCP
]])

prepend_path("MODULEPATH", "/apps/hpc-stack/libs/hpc-stack/modulefiles/stack")

local hpc_ver=os.getenv("hpc_ver") or "1.2.0"
local hpc_intel_ver=os.getenv("hpc_intel_ver") or "2021.3.0"
local hpc_impi_ver=os.getenv("hpc_impi_ver") or "2021.3.0"

local jasper_ver=os.getenv("jasper_ver") or "2.0.25"
local zlib_ver=os.getenv("zlib_ver") or "1.2.11"
local libpng_ver=os.getenv("libpng_ver") or "1.6.35"

load(pathJoin("hpc", hpc_ver))
load(pathJoin("hpc-intel", hpc_intel_ver))
load(pathJoin("hpc-impi", hpc_impi_ver))

load(pathJoin("jasper", jasper_ver))
load(pathJoin("zlib", zlib_ver))
load(pathJoin("png", libpng_ver))

load("gfsutils_common")

whatis("Description: GFS utilities environment on GCP with Intel Compilers")
