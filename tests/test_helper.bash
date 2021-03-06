unset ROSE_SH_VERSION
unset ROSE_SH_DIR

ROSE_SH_TESTS_HOME="$(cd "$(dirname "$0")" && pwd)"

#--------------------------------------------------------------------
# Modules
#--------------------------------------------------------------------
source "${ROSE_SH_TESTS_HOME}/../../../lib/import.shinc"

#--------------------------------------------------------------------
# Run in strict-mode
#--------------------------------------------------------------------
shopt -s extglob  # enable extended globs
set -o errtrace   # fail if any statement returns non-zero
set -o errexit    # fail if command fails
set -o nounset    # fail if variable is not set, i.e. "unbound"
set -o pipefail   # fail if any command in a pipeline fails

# Required by BATS, otherwise no output
set +o nounset


: ${TMPDIR:=/tmp}
: ${BATS_TMPDIR:="$TMPDIR"}
: ${ROSE_SH_ROOT:=}
: ${ROSE_SH_TEST_DIR:="${BATS_TMPDIR}/rose-sh"}

# guard against executing this block twice due to bats internals
if [ "$ROSE_SH_ROOT" != "${ROSE_SH_TEST_DIR}/root" ]; then
  export ROSE_SH_ROOT="${ROSE_SH_TEST_DIR}/root"
  export ROSE_SH_BIN="${ROSE_SH_ROOT}/bin"
  export HOME="${ROSE_SH_TEST_DIR}/home"

  PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
  PATH="${ROSE_SH_TEST_DIR}/bin:$PATH"
  PATH="${BATS_TEST_DIRNAME}/../bin:$PATH"
  PATH="${ROSE_SH_ROOT}/shims:$PATH"
  export PATH
fi

teardown() {
  rm -rf "$ROSE_SH_TEST_DIR"
}

flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed "s:${ROSE_SH_TEST_DIR}:TEST_DIR:g" >&2
  return 1
}

assert_success() {
  if [ "$status" -ne 0 ]; then
    flunk "command failed with exit status $status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_failure() {
  if [ "$status" -eq 0 ]; then
    flunk "expected failed exit status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    { echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

assert_output() {
  local expected
  if [ $# -eq 0 ]; then expected="$(cat -)"
  else expected="$1"
  fi
  assert_equal "$expected" "$output"
}

assert_no_output() {
  local num_lines="${#lines[@]}"
  if [ "$num_lines" -gt "0" ]; then
    { echo "output not expected"
      echo "output: ${lines[@]}"
    } | flunk
  fi
}

assert_line() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    assert_equal "$2" "${lines[$1]}"
  else
    local line
    for line in "${lines[@]}"; do
      if [ "$line" = "$1" ]; then return 0; fi
    done
    { echo "expected: \`$1'"
      echo "actual:   ${lines[@]}"
    } | flunk
  fi
}

refute_line() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    local num_lines="${#lines[@]}"
    if [ "$1" -lt "$num_lines" ]; then
      flunk "output has $num_lines lines"
    fi
  else
    local line
    for line in "${lines[@]}"; do
      if [ "$line" = "$1" ]; then
        flunk "expected to not find line \`$line'"
      fi
    done
  fi
}

assert() {
  if ! "$@"; then
    flunk "failed: $@"
  fi
}

# Output a modified PATH that ensures that the given executable is not present,
# but in which system utils necessary for install-local operation are still available.
path_without() {
  local exe="$1"
  local path="${PATH}:"
  local found alt util
  for found in $(which -a "$exe"); do
    found="${found%/*}"
    if [ "$found" != "${ROSE_SH_ROOT}/shims" ]; then
      alt="${ROSE_SH_TEST_DIR}/$(echo "${found#/}" | tr '/' '-')"
      mkdir -p "$alt"
      for util in bash head cut readlink greadlink; do
        if [ -x "${found}/$util" ]; then
          ln -s "${found}/$util" "${alt}/$util"
        fi
      done
      path="${path/${found}:/${alt}:}"
    fi
  done
  echo "${path%:}"
}
