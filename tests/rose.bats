#!/usr/bin/env bats

#--------------------------------------------------------------------
# Run in strict-mode
#--------------------------------------------------------------------
shopt -s extglob  # enable extended globs
set -o errtrace   # fail if any statement returns non-zero
set -o errexit    # fail if command fails
set -o pipefail   # fail if any command in a pipeline fails

#--------------------------------------------------------------------
# Modules
#--------------------------------------------------------------------
load test_helper

#--------------------------------------------------------------------
# Tests
#--------------------------------------------------------------------

@test "log INFO message" {
  local LOG_LEVEL=INFO
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose-log rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Using INFO logger
  run rose-log rose::log::info "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}
