#!/usr/bin/env bash

#---
# Help screen
#---

function help() {
  cat << EOF
Installation script for vxOpenLibm project (fork of OpenLibm)

Usage: $0 [options...]

Options:
  -h, --help            display this help
  -y, --yes             do not display validation step
      --verbose         display more information during operations
      --prefix-sysroot  sysroot (install) prefix path

Notes:
    This project is mainly automatically installed as a dependency of the
  sh-elf-vhex (Vhex's compiler) project. So, the verbose option can also be
  trigger using the env var VHEX_VERBOSE.
EOF
  exit 0
}

#---
# Parse arguments
#---

verbose=true
skip_input=false
prefix='None'
for arg; do
  case "$arg" in
    -h | --help)                help;;
    -y | --yes)                 skip_input=true;;
    -v | --verbose)             verbose=true;;
         --prefix-sysroot=*)    prefix=${arg#*=};;
    *)
      echo "error: unreconized argument '$arg', giving up." >&2
      exit 1
  esac
done

#---
# Preliminary check
#---

_src=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$_src" || exit 1
source ./_utils.sh

if [[ ! $(sh-elf-vhex-gcc --version) ]]
then
  echo -e \
    'You need to install the sh-elf-vhex compiler to install this '       \
    'project.\n'                                                          \
    'Also note that the installation if the compiler will automatically ' \
    'install this project'
  exit 1
fi

if [[ -d '../openlibm' ]]
then
  echo 'OpenLibm already exists, abord' >&2
  exit 1
fi

[[ "$verbose" == 'true' ]] && VHEX_VERBOSE='true'
[[ "$prefix" != 'None' ]] && VHEX_PREFIX_SYSROOT="$prefix"
export VHEX_VERBOSE
export VHEX_PREFIX_SYSROOT

SYSROOT=$(utils_get_env 'VHEX_PREFIX_SYSROOT' 'sysroot')
VERBOSE=$(utils_get_env 'VHEX_VERBOSE' 'verbose')

if [[ "$skip_input" != 'true' ]]
then
  echo 'This script will compile and install the vxOpenLibm project'
  echo "  - prefix  = $SYSROOT"
  echo "  - verbose = $VERBOSE"
  read -p 'Perform operations [Yn] ? ' -r valid
  if [[ "$valid" == 'n' ]]; then
    echo 'Operation aborted' >&2
    exit 1
  fi
fi

#---
# Build / install operations
#---

source ./_utils.sh

TAG='<vxOpenLibm>'

echo "$TAG clone openlibm..."
callcmd \
  git clone https://github.com/JuliaMath/openlibm.git --depth 1 ../openlibm

echo "$TAG patch openlibm sources..."
cp -r ../patches/* ../openlibm

echo "$TAG building..."
callcmd cmake \
  -DCMAKE_INSTALL_PREFIX="$SYSROOT" \
  -DCMAKE_TOOLCHAIN_FILE=../patches/toolchain.cmake \
  -B ../openlibm/_build-vhex/ \
  -S ../openlibm/

callcmd cmake --build ../openlibm/_build-vhex/

callcmd cmake --install ../openlibm/_build-vhex/
