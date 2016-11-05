#!/usr/bin/env bats

shopt -s extglob
set -o errtrace
set -o errexit

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

  # Log level not enabled
  run rose-log rose::log::debug "${LOG_MESSAGE}"
  assert_success
  assert_no_output

  # Log level is enabled
  LOG_LEVEL="${LOG_LEVEL_DEBUG}" \
      run rose-log rose::log::debug "${LOG_MESSAGE}"
  assert_success
  #assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log WARN message" {
  local LOG_LEVEL=WARN
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose-log rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level not enabled
  run rose-log rose::log::warn "${LOG_MESSAGE}"
  assert_success
  assert_no_output

  # Log level is enabled

  LOG_LEVEL="${LOG_LEVEL_WARN}" \
      run rose-log rose::log::warn "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log TRACE message" {
  local LOG_LEVEL=TRACE
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose-log rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level not enabled
  run rose-log rose::log::trace "${LOG_MESSAGE}"
  assert_success
  assert_no_output

  # Log level is enabled

  LOG_LEVEL="${LOG_LEVEL_TRACE}" \
      run rose-log rose::log::trace "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log ERROR message" {
  local LOG_LEVEL=ERROR
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose-log rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level not enabled
  run rose-log rose::log::error "${LOG_MESSAGE}"
  assert_success
  assert_no_output

  # Log level is enabled

  LOG_LEVEL="${LOG_LEVEL_ERROR}" \
      run rose-log rose::log::error "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}

@test "log FATAL message" {
  local LOG_LEVEL=FATAL
  local LOG_MESSAGE="Test log message"

  # Using low-level logger
  run rose-log rose::log::log "${LOG_LEVEL}" "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"

  # Log level not enabled
  run rose-log rose::log::fatal "${LOG_MESSAGE}"
  assert_success
  assert_no_output

  # Log level is enabled

  LOG_LEVEL="${LOG_LEVEL_FATAL}" \
      run rose-log rose::log::fatal "${LOG_MESSAGE}"
  assert_success
  assert_line "[${LOG_LEVEL}] ${LOG_MESSAGE}"
}


