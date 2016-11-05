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

# @test "log INFO message" {
#   :
# }
