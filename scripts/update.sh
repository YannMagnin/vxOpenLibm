#!/usr/bin/env bash

#---
# Help screen
#---

function help() {
  cat << EOF
Update script the for vxOpenLibm script (fork of OpenLibm)

Usage: $0 [options...]

Options:
  -h, --help        display this help
  -y, --yes         do not display validation step
  -v, --verbose     display more information during operations

Notes:
    This project is a dependency of "sh-elf-vhex" compiler, manual
  uninstallation can break all the toolchain.
EOF
  exit 0
}

#---
# Parse arguments
#---

verbose=false
skip_input=false
for arg; do
  case "$arg" in
    -h | --help)    help;;
    -y | --yes)     skip_input=true;;
    -v | --verbose) verbose=true;;
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

if ! test -f '../openlibm/_build-vhex/sysroot.txt'
then
  echo 'vxOpenLibm not installed, nothing to do'
  exit 0
fi
prefix=$(cat '../openlibm/_build-vhex/sysroot.txt')

if [[ "$skip_input" != 'true' ]]
then
  echo "This script will update the vxOpenLibm for the sysroot '$prefix'"
  read -p 'Perform operation [Yn] ? ' -r valid
  if [[ "$valid" == 'n' ]]
  then
    echo 'Operation aborded' >&2
    exit 1
  fi
fi

#---
# Manual update
#---

[[ "$verbose" == 'true' ]] && export VERBOSE=1

if test -d '../.git'
then
  echo "$TAG try to bump the repository..."
  callcmd git pull
else
  echo "$TAG WARNING: not a git repository"
fi

echo "$TAG update operation will reclone and rebuild the project..."
./install.sh --prefix-sysroot="$prefix" --yes --overwrite
