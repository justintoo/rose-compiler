# Escape \cd to use the native cd and not a user's possible alias of cd
export ROSE_SH_HOME="$(\cd "$(dirname "${BASH_SOURCE}")" && pwd)"
export PATH="${ROSE_SH_HOME}/bin:${PATH}"
