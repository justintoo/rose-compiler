#!/usr/bin/env bats

#--------------------------------------------------------------------
# Run in strict-mode
#--------------------------------------------------------------------
shopt -s extglob  # enable extended globs
set -o errtrace   # fail if any statement returns non-zero
set -o errexit    # fail if command fails
set -o nounset    # fail if variable is not set, i.e. "unbound"
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

@test "log DEBUG message" {
  local LOG_LEVEL=DEBUG
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose-log rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level is enabled
  LOG_LEVEL="${LOG_LEVEL_DEBUG}" \
      run rose-log rose::log::debug "${LOG_MESSAGE}"
  assert_success

  # Log level is NOT enabled
  LOG_LEVEL="9999999" \
      run rose-log rose::log::debug "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log WARN message" {
  local LOG_LEVEL=WARN
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose-log rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level is enabled
  LOG_LEVEL="${LOG_LEVEL_WARN}" \
      run rose-log rose::log::warn "${LOG_MESSAGE}"
  assert_success

  # Log level is NOT enabled
  LOG_LEVEL="9999999" \
      run rose-log rose::log::warn "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log TRACE message" {
  local LOG_LEVEL=TRACE
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose-log rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level is enabled
  LOG_LEVEL="${LOG_LEVEL_TRACE}" \
      run rose-log rose::log::trace "${LOG_MESSAGE}"
  assert_success

  # Log level is NOT enabled
  LOG_LEVEL="9999999" \
      run rose-log rose::log::trace "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log ERROR message" {
  local LOG_LEVEL=ERROR
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose-log rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level is enabled
  LOG_LEVEL="${LOG_LEVEL_ERROR}" \
      run rose-log rose::log::error "${LOG_MESSAGE}"
  assert_success

  # Log level is NOT enabled
  LOG_LEVEL="9999999" \
      run rose-log rose::log::error "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log FATAL message" {
  local LOG_LEVEL=FATAL
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose-log rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level is enabled
  LOG_LEVEL="${LOG_LEVEL_FATAL}" \
      run rose-log rose::log::fatal "${LOG_MESSAGE}"
  assert_success

  # Log level is NOT enabled
  LOG_LEVEL="9999999" \
      run rose-log rose::log::fatal "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log INFO messages on by default" {
  local LOG_LEVEL=INFO
  local LOG_MESSAGE="Test log message"

  # Log level not set => INFO is on by default
  LOG_LEVEL="" \
      run rose-log rose::log::info "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log DEBUG messages on by default" {
  local LOG_LEVEL=DEBUG
  local LOG_MESSAGE="Test log message"

  # Log level not set => DEBUG is on by default
  LOG_LEVEL="" \
      run rose-log rose::log::debug "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log WARN messages on by default" {
  local LOG_LEVEL=WARN
  local LOG_MESSAGE="Test log message"

  # Log level not set => WARN is on by default
  LOG_LEVEL="" \
      run rose-log rose::log::warn "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log TRACE messages off by default" {
  local LOG_LEVEL=TRACE
  local LOG_MESSAGE="Test log message"

  # Log level not set => TRACE is off by default
  LOG_LEVEL="" \
      run rose-log rose::log::trace "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log ERROR messages on by default" {
  local LOG_LEVEL=ERROR
  local LOG_MESSAGE="Test log message"

  # Log level not set => ERROR is on by default
  LOG_LEVEL="" \
      run rose-log rose::log::error "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log FATAL messages on by default" {
  local LOG_LEVEL=FATAL
  local LOG_MESSAGE="Test log message"

  # Log level not set => FATAL is on by default
  LOG_LEVEL="" \
      run rose-log rose::log::fatal "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log queued strings" {
  local MESSAGES=("1" "2" "3" "4" "5")

  # Queue messages
  for message in "${MESSAGES[@]}"; do
      run rose-log rose::log::queue "$message"
      assert_success
      assert_no_output
  done

  # Output queued messages
  run rose-log rose::log::flush

  # Validate messages
  for message in "${MESSAGES[@]}"; do
      assert_line "$message"
  done
}

@test "log queued log messages" {
  local LOG_LEVELS=("INFO" "DEBUG" "WARN" "TRACE" "ERROR" "FATAL")
  local LOG_MESSAGES=("info message" "debug message" "warn message" "trace message" "error message" "fatal message")

  # Queue messages
  for ((i=0; i<${#LOG_LEVELS[*]}; i++)); do
      run rose-log rose::log::queue "$(rose-log rose::log::log "${LOG_LEVELS[$i]}" "${LOG_MESSAGES[$i]}")"
      assert_success
      assert_no_output
  done

  # Output queued messages
  output="$(run rose-log rose::log::flush)"
  assert_success

  # <TODO> Compare line-by-line
  assert test -n \"${output}\"
}

