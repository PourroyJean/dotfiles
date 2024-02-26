#!/bin/bash

# Source me to get the correct configure/build/run environment

if [[ $# -eq 0 ]]; then
  echo "Usage: . ./env.sh  <env>"
  echo ""
  echo "Possible env:"
  echo "  - gpu"
  echo "  - special"
  return 1
else



# Store tracing and disable (module is *way* too verbose)
{ tracing_=${-//[^x]/}; set +x; } 2>/dev/null

module_load() {
  echo "+ module load $1"
  if [ "${2:-""}" == "ECBUNDLE_CONFIGURE_ONLY" ]; then
    if [ -n "${ECBUNDLE_CONFIGURE:-""}" ]; then
      module load $1
    else
      echo " WARNING: Module $1 not loaded (only during configuration)"
    fi
  else
    module load $1
  fi
}

module_unload() {
  echo "+ module unload $1"
  module unload $1
}


case $1 in
        "gpu")

  echo "---> LOADING ENV GPU"
  module_load craype-x86-trento
  module_load craype-accel-amd-gfx90a
  module_load rocm
  echo ""


        ;;

        "special")

  echo "---> LOADING ENV SPECIAL to be done"


        ;;


        *)
                echo "Unknown env name"
                return 1
        ;;
esac
fi




echo "---> ENV CHECK "
module list 2>&1
set -x
ulimit -S -s unlimited

# Restore tracing to stored setting
{ if [[ -n "$tracing_" ]]; then set -x; else set +x; fi } 2>/dev/null