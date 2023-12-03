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
  sh-elf-vhex (Vhex's compiler) project.
EOF
  exit 0
}

#---
# Parse arguments
#---

verbose=false
skip_input=false
prefix=''
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

if test -z "$prefix"
then
  echo 'You need to specify the sysroot prefix, abord' >&2
  exit 1
fi

if [[ ! $(sh-elf-vhex-gcc --version) ]]
then
  echo -e \
    'You need to install the sh-elf-vhex compiler to install this '       \
    'project.\n'                                                          \
    'Also note that the installation if the compiler will automatically ' \
    'install this project'
  exit 1
fi

_src=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$_src" || exit 1
source ./_utils.sh

if [[ -d '../openlibm' ]]
then
  echo 'OpenLibm already exists, abord' >&2
  exit 1
fi

if [[ "$skip_input" != 'true' ]]
then
  echo 'This script will compile and install the vxOpenLibm project'
  echo "  - prefix  = $prefix"
  echo "  - verbose = $verbose"
  read -p 'Perform operations [Yn] ? ' -r valid
  if [[ "$valid" == 'n' ]]; then
    echo 'Operation aborted' >&2
    exit 1
  fi
fi

[[ "$verbose" == 'true' ]] && export VERBOSE=1

#---
# Build / install operations
#---

echo "$TAG clone openlibm..."
callcmd \
  git clone https://github.com/JuliaMath/openlibm.git --depth 1 ../openlibm

echo "$TAG patch openlibm sources..."
cp -r ../patches/* ../openlibm

echo "$TAG configure..."
callcmd \
  cmake \
  -DCMAKE_INSTALL_PREFIX="$prefix" \
  -DCMAKE_TOOLCHAIN_FILE=../patches/toolchain.cmake \
  -B ../openlibm/_build-vhex/ \
  -S ../openlibm/

echo "$TAG build..."
callcmd cmake --build ../openlibm/_build-vhex/

echo "$TAG install..."
callcmd cmake --install ../openlibm/_build-vhex/
