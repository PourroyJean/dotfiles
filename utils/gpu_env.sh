#!/bin/zsh
ulimit -c unlimited
ulimit -s unlimited

# Store tracing and disable (module is *way* too verbose)
tracing_=${options[xtrace]:+"x"}
set +x 2>/dev/null

module_load() {
  echo "+ module load $1"
  if [[ "${2:-""}" == "ECBUNDLE_CONFIGURE_ONLY" ]]; then
    if [[ -n "${ECBUNDLE_CONFIGURE:-""}" ]]; then
      module load "$1"
    else
      echo " WARNING: Module $1 not loaded (only during configuration)"
    fi
  else
    module load "$1"
  fi
}

module_unload() {
  echo "+ module unload $1"
  module unload "$1"
}

module_load PrgEnv-cray
module_load craype-x86-trento
module_load craype-accel-amd-gfx90a
module_load rocm

export MPICH_GPU_SUPPORT_ENABLED=1

module list 2>&1
