#!/usr/bin/env bats

load test_helper

#--------------------------------------------------------------------
# Modules
#--------------------------------------------------------------------
import util/logging


#--------------------------------------------------------------------
# Tests
#--------------------------------------------------------------------
@test "no argument shows --help" {
  local LOG_LEVEL=INFO
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Using INFO logger
  run rose::log::info "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "stdout message" {
  local LOG_MESSAGE="Test log message"

  # Using stdout logger
  run rose::log::stdout "${LOG_MESSAGE}"
  assert_success
  assert_line "${LOG_MESSAGE}"
}

@test "log message" {
  local LOG_LEVEL=INFO
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log INFO message" {
  local LOG_LEVEL=INFO
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level is enabled
  LOG_LEVEL="${LOG_LEVEL_INFO}" \
      run rose::log::info "${LOG_MESSAGE}"
  assert_success

  # Log level is NOT enabled
  ROSE_SH_LOG_LEVEL="9999999" \
      run rose::log::info "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log DEBUG message" {
  local LOG_LEVEL=DEBUG
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level is enabled
  ROSE_SH_LOG_LEVEL="${LOG_LEVEL_DEBUG}" \
      run rose::log::debug "${LOG_MESSAGE}"
  assert_success

  # Log level is NOT enabled
  ROSE_SH_LOG_LEVEL="9999999" \
      run rose::log::debug "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log WARN message" {
  local LOG_LEVEL=WARN
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level is enabled
  ROSE_SH_LOG_LEVEL="${LOG_LEVEL_WARN}" \
      run rose::log::warn "${LOG_MESSAGE}"
  assert_success

  # Log level is NOT enabled
  ROSE_SH_LOG_LEVEL="9999999" \
      run rose::log::warn "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log TRACE message" {
  local LOG_LEVEL=TRACE
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level is enabled
  ROSE_SH_LOG_LEVEL="${LOG_LEVEL_TRACE}" \
      run rose::log::trace "${LOG_MESSAGE}"
  assert_success

  # Log level is NOT enabled
  ROSE_SH_LOG_LEVEL="9999999" \
      run rose::log::trace "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log ERROR message" {
  local LOG_LEVEL=ERROR
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level is enabled
  ROSE_SH_LOG_LEVEL="${LOG_LEVEL_ERROR}" \
      run rose::log::error "${LOG_MESSAGE}"
  assert_success

  # Log level is NOT enabled
  ROSE_SH_LOG_LEVEL="9999999" \
      run rose::log::error "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log FATAL message" {
  local LOG_LEVEL=FATAL
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level is enabled
  ROSE_SH_LOG_LEVEL="${LOG_LEVEL_FATAL}" \
      run rose::log::fatal "${LOG_MESSAGE}"
  assert_success

  # Log level is NOT enabled
  ROSE_SH_LOG_LEVEL="9999999" \
      run rose::log::fatal "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log INFO messages on by default" {
  local LOG_LEVEL=INFO
  local LOG_MESSAGE="Test log message"

  # Log level not set => INFO is on by default
  ROSE_SHLOG_LEVEL="" \
      run rose::log::info "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log DEBUG messages on by default" {
  local LOG_LEVEL=DEBUG
  local LOG_MESSAGE="Test log message"

  # Log level not set => DEBUG is on by default
  ROSE_SHLOG_LEVEL="" \
      run rose::log::debug "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log WARN messages on by default" {
  local LOG_LEVEL=WARN
  local LOG_MESSAGE="Test log message"

  # Log level not set => WARN is on by default
  ROSE_SH_LOG_LEVEL="" \
      run rose::log::warn "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log TRACE messages off by default" {
  local LOG_LEVEL=TRACE
  local LOG_MESSAGE="Test log message"

  # Log level not set => TRACE is off by default
  run rose::log::trace "${LOG_MESSAGE}"
  assert_success
  assert_no_output
}

@test "log ERROR messages on by default" {
  local LOG_LEVEL=ERROR
  local LOG_MESSAGE="Test log message"

  # Log level not set => ERROR is on by default
  ROSE_SH_LOG_LEVEL="" \
      run rose::log::error "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log FATAL messages on by default" {
  local LOG_LEVEL=FATAL
  local LOG_MESSAGE="Test log message"

  # Log level not set => FATAL is on by default
  ROSE_SH_LOG_LEVEL="" \
      run rose::log::fatal "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log FATAL abort message" {
  local LOG_LEVEL=FATAL
  local LOG_MESSAGE="Abort log message"

  # Using stdout logger
  run rose::log::abort "${LOG_MESSAGE}"
  assert_failure
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log queued strings" {
  local MESSAGES=("1" "2" "3" "4" "5")

  # Queue messages
  for message in "${MESSAGES[@]}"; do
      run rose::log::queue "$message"
      assert_success
      assert_no_output
  done

  # Output queued messages
  run rose::log::flush

  # Validate messages
  for message in "${MESSAGES[@]}"; do
      assert_line "$message"
  done
}

@test "log queued messages" {
  local MESSAGES=("1" "2" "3" "4" "5")

  # Queue messages
  for message in "${MESSAGES[@]}"; do
      run rose::log::queue "$message"
      assert_success
      assert_no_output
  done

  # Output queued messages
  run rose::log::flush

  # Validate messages
  for message in "${MESSAGES[@]}"; do
      assert_line "$message"
  done

  # No messages in the queue
  ROSE_SH_LOG_QUEUE=
  run rose::log::flush
  assert_no_output

  local LOG_LEVELS=("INFO" "DEBUG" "WARN" "TRACE" "ERROR" "FATAL")
  local LOG_MESSAGES=("info message" "debug message" "warn message" "trace message" "error message" "fatal message")

  # Queue messages
  for ((i=0; i<${#LOG_LEVELS[*]}; i++)); do
      run rose::log::queue "$(rose::log::log "${LOG_LEVELS[$i]}" "${LOG_MESSAGES[$i]}")"
      assert_success
      assert_no_output
  done

  # Output queued messages
  output="$(run rose::log::flush)"
  assert_success

  # <TODO> Compare line-by-line
  assert test -n \"${output}\"
}
