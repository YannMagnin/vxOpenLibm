# module used to provide common variable / functions
# this file must not be manually invoked

#---
# Internals
#---

# workaround used to self-kill the current process if an error is detected
# in function
trap 'exit 1' TERM
export TOP_PID=$$

#---
# Public
#---

# abstract the verbose mode
function callcmd() {
  if [[ -v 'VHEX_VERBOSE' ]]
    then
      echo "$@"
      if ! "$@"; then
        echo "$TAG error: command failed, abord"
        kill -s TERM $TOP_PID
      fi
  else
    out='vxopenlibm_crash.txt'
    if ! "$@" >"$out" 2>&1; then
      echo "$TAG error: command failed, please check $(pwd)/$out o(x_x)o" >&2
      echo "$@" >&2
      kill -s TERM $TOP_PID
    fi
    rm -f "$out"
  fi
}

# check env information
function utils_get_env() {
  if [ ! -v "$1" ]
  then
    echo 'error: are you sure to use the bootstrap script ?' >&2
    echo " Missing $2 information, abord" >&2
    kill -s TERM $TOP_PID
  fi
  echo "${!1/#\~/$HOME}"
}
