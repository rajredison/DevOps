#!/bin/bash --norc

SPACK_ROOT="/software/spack"
BINDIR="${SPACK_ROOT}/opt/spack/linux-rhel8-x86_64_v3/gcc-8.5.0"

# Check if lmod is in the environment
if [[ -z "$LMOD_VERSION" ]]; then
    echo "... configuring your environment to use modules (lmod)"

    # Use a temporary directory if needed, but avoid hardcoding /scratch
    # as it might not exist on all systems.  Consider $TMPDIR or /tmp.
    # export TMP="/tmp"  # Or use $TMPDIR if set

    # Source the lmod initialization script.  Use the full path.
    . "${BINDIR}/lmod-8.7.24-yvrdfit/lmod/lmod/init/bash"

    # Define MODULEPATH.  It's good practice to start with a clean path.
    MODULEPATH="/software/spack/share/spack/modules/linux-rhel8-x86_64_v3/"

    # Check for sbgrid modules and add to MODULEPATH if found.
    _sbgrid="/programs/share/modulefiles/x86_64-linux/sbgrid/"
    if [[ -d "$_sbgrid" ]]; then
        MODULEPATH="$_sbgrid:$MODULEPATH" # Prepend sbgrid path for priority
        # Or append, if you prefer:
        # MODULEPATH="$MODULEPATH:$_sbgrid"
    fi

    # Export MODULEPATH.  Crucially important!
    export MODULEPATH

else
    echo "... lmod already initialized (LMOD_VERSION: $LMOD_VERSION)"
fi


# Example usage (optional):
# module avail
# module load <module_name>