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

6 tests, 0 failures
``

