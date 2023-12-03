#!/usr/bin/env bash

#---
# Help screen
#---

function help() {
  cat << EOF
Uninstallation script for vxOpenLibm project (fork of OpenLibm)

Usage: $0 [options...]

Options:
  -h, --help        display this help
  -y, --yes         do not display validation step
      --quiet       do not display information during operations

Notes:
    This project is a dependency of "sh-elf-vhex" compiler, manual
  uninstallation can break all the toolchain.
EOF
  exit 0
}

#---
# Parse arguments
#---

verbose=true
skip_input=false
for arg; do
  case "$arg" in
    -h | --help)    help;;
    -y | --yes)     skip_input=true;;
         --quiet)   verbose=false;;
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

if ! test -f '../_openlibm/_build-vhex/install_manifest.txt'
then
  echo 'vxOpenLibm not installed, nothing to do'
  exit 0
fi

if [[ "$skip_input" != 'true' ]]
then
  echo 'This script will remove the vxOpenLibm from the builded sysroot'
  read -p 'Perform operation [yN] ? ' -r valid
  if [[ "$valid" != 'y' ]]
  then
    echo 'Operation aborded' >&2
    exit 1
  fi
fi

#---
# Manual uninstall
#---

echo "$TAG removing installed files..."
while IFS='' read -r line || [[ -n "$line" ]]
  do
    ! test -f "$line" && continue
    [[ "$verbose" == 'true' ]] && echo "rm $line"
    rm "$line"
  done < '../_openlibm/_build-vhex/install_manifest.txt'
