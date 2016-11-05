The test suite for `rose-sh` currently utilizes the [Bash Automated Testing System (sstephenson/bats)](https://github.com/sstephenson/bats).

### Usage Example

``bash
$ ./run-tests.sh
[INFO] running test tests/rose-log.bats
 ✓ log INFO message
 ✓ log DEBUG message
 ✓ log WARN message
 ✓ log TRACE message
 ✓ log ERROR message
 ✓ log FATAL message
 ✓ log INFO messages on by default
 ✓ log DEBUG messages on by default
 ✓ log WARN messages on by default
 ✓ log TRACE messages off by default
 ✓ log ERROR messages on by default
 ✓ log FATAL messages on by default
 ✓ log queued strings
 ✓ log queued log messages

14 tests, 0 failures
``

