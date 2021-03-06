#!/usr/bin/env bash

#--------------------------------------------------------------------
# Run in strict-mode
#--------------------------------------------------------------------
shopt -s extglob  # enable extended globs
set -o errtrace   # fail if any statement returns non-zero
set -o errexit    # fail if command fails
set -o pipefail   # fail if any command in a pipeline fails

#--------------------------------------------------------------------
# Logistics
#--------------------------------------------------------------------
export ROSE_SH_TESTS_HOME="$(cd "$(dirname "$0")" && pwd)"
export ROSE_SH_HOME="$(cd "${ROSE_SH_TESTS_HOME}/.." && pwd)"
export ROSE_SH_LIB_HOME="${ROSE_SH_HOME}/lib"
export ROSE_SH_TESTS="${ROSE_SH_HOME}/tests"
export ROSE_SH_BATS="${ROSE_SH_TESTS}/bats"

#--------------------------------------------------------------------
# Modules
#--------------------------------------------------------------------
export PATH="${ROSE_SH_BATS}/bin:${PATH}"

source "${ROSE_SH_LIB_HOME}/import.shinc" || false

  import util/logging

#------------------------------------------------------------------------------
# Test API
#------------------------------------------------------------------------------
function make_check::list_tests() {
  for test_path in $(find "${ROSE_SH_TESTS}" -maxdepth 2 -iname "*\.bats" -type f ! -path "${ROSE_SH_TESTS}"); do
    test_name="$(basename "${test_path}")"
    test_dir="$(dirname "${test_path}")"
    test_dir_parent="$(basename "${test_dir}")"

    rose::log::queue "$(rose::log::debug "test_path=${test_path}")"
    rose::log::queue "$(rose::log::debug "tool_dir=${test_dir}")"
    rose::log::queue "$(rose::log::debug "tool_dir_parent=${test_dir_parent}")"

    echo "${test_dir_parent}/${test_name}"
  done
}

#------------------------------------------------------------------------------
# Main
#------------------------------------------------------------------------------
function make_check::main() {
  for test_name in $(make_check::list_tests); do
      rose::log::stdout "Running test ${test_name}"
      bats "${test_name}"
  done

  rose::log::flush
}

make_check::main "$@"
