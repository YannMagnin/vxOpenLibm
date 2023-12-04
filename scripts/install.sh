#!/usr/bin/env bash

#---
# Help screen
#---

function help() {
  cat << EOF
Installation script for the vxOpenLibm project (fork of OpenLibm)

Usage: $0 [options...]

Options:
  -h, --help            display this help
  -y, --yes             do not display validation step
  -v, --verbose         display more information during operations
      --prefix-sysroot  sysroot (install) prefix path
      --overwrite       remove the cloned OpenLibm repo if already exists

Notes:
    This project is mainly installed automatically as a dependency of the
  sh-elf-vhex (Vhex's compiler) project.
EOF
  exit 0
}

#---
# Parse arguments
#---

verbose=false
skip_input=false
overwrite=false
prefix=''
for arg; do
  case "$arg" in
    -h | --help)                help;;
    -y | --yes)                 skip_input=true;;
    -v | --verbose)             verbose=true;;
         --prefix-sysroot=*)    prefix=${arg#*=};;
         --overwrite)           overwrite=true;;
    *)
      echo "error: unrecognized argument '$arg', giving up." >&2
      exit 1
  esac
done

#---
# Preliminary check
#---

if test -z "$prefix"
then
  echo 'You need to specify the sysroot prefix, abort' >&2
  exit 1
fi

if [[ ! $(sh-elf-vhex-gcc --version) ]]
then
  echo -e \
    'You need to install the "sh-elf-vhex" compiler to install this '     \
    'project.\n'                                                          \
    'Also note that the installation of the compiler will automatically ' \
    'install this project'
  exit 1
fi

_src=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$_src" || exit 1
source ./_utils.sh

if [[ -d '../_openlibm' &&  "$overwrite" != 'true' ]]
then
  echo 'vxOpenLibm already installed, nothing to do'
  exit 0
fi

if [[ "$skip_input" != 'true' ]]
then
  echo 'This script will compile and install the vxOpenLibm project'
  echo "  - prefix    = $prefix"
  echo "  - verbose   = $verbose"
  echo "  - overwrite = $overwrite"
  read -p 'Perform operations [Yn] ? ' -r valid
  if [[ "$valid" == 'n' ]]; then
    echo 'Operations aborted' >&2
    exit 1
  fi
fi

[[ -d '../_openlibm' ]] && rm -rf ../_openlibm

[[ "$verbose" == 'true' ]] && export VERBOSE=1

#---
# Build / install operations
#---

echo "$TAG clone openlibm..."
callcmd \
  git clone https://github.com/JuliaMath/openlibm.git --depth 1 ../_openlibm

echo "$TAG patch openlibm sources..."
cp -r ../patches/* ../_openlibm

echo "$TAG configure..."
callcmd \
  cmake \
  -DCMAKE_INSTALL_PREFIX="$prefix" \
  -DCMAKE_TOOLCHAIN_FILE=../patches/toolchain.cmake \
  -B ../_openlibm/_build-vhex/ \
  -S ../_openlibm/

echo "$TAG build..."
callcmd cmake --build ../_openlibm/_build-vhex/

echo "$TAG install..."
callcmd cmake --install ../_openlibm/_build-vhex/
echo "$prefix" > ../_openlibm/_build-vhex/sysroot.txt
