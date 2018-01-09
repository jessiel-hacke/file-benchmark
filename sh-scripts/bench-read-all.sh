#!/bin/bash

# execute_file(command, test_file, test_type, test_mode, verbose)
execute_test() {
  start=$(date +%s.%N)

  COMMAND="TEST_NAME='$1' TEST_FILE='$2' TEST_TYPE='$3' TEST_MODE='$4' VERBOSE='$5' $6 >> reports/results/read/$1.txt"

  eval $COMMAND

  dur=$(echo "$(date +%s.%N) - $start" | bc)

  LC_NUMERIC="C.UTF-8" printf "Shell Execution Time: %.4fs\n\n" $dur >> reports/results/read/"$1".txt
}

execute_all() {
  TEST_FILENAME=$1

  execute_test $2 $TEST_FILENAME "read" "full" "true" "crystal tests/crystal/runner.cr"
  # Crystal (Stream)
  execute_test $2 $TEST_FILENAME "read" "stream" "true" "crystal tests/crystal/runner.cr"

  # Elixir (Full)
  execute_test $2 $TEST_FILENAME "read" "full" "true" "elixir tests/elixir/runner.ex"
  # Elixir (Stream)
  execute_test $2 $TEST_FILENAME "read" "stream" "true" "elixir tests/elixir/runner.ex"

  # GoLang (Full)
  execute_test $2 $TEST_FILENAME "read" "full" "true" "go run tests/go/read.go"
  # GoLang (Stream)
  execute_test $2 $TEST_FILENAME "read" "stream" "true" "go run tests/go/read.go"

  # Lua (Full)
  execute_test $2 $TEST_FILENAME "read" "full" "true" "lua tests/lua/read.lua"
  # Lua (Stream)
  execute_test $2 $TEST_FILENAME "read" "stream" "true" "lua tests/lua/read.lua"

  # NodeJS (Full)
  execute_test $2 $TEST_FILENAME "read" "full" "true" "node tests/nodejs/runner.js"
  # NodeJS (Stream)
  execute_test $2 $TEST_FILENAME "read" "stream" "true" "node tests/nodejs/runner.js"

  # Python (Full)
  execute_test $2 $TEST_FILENAME "read" "full" "true" "python tests/python/runner.py"
  # Python (Stream)
  execute_test $2 $TEST_FILENAME "read" "stream" "true" "python tests/python/runner.py"

  # Ruby (Full)
  execute_test $2 $TEST_FILENAME "read" "full" "true" "ruby tests/ruby/runner.rb"
  # Ruby (Stream)
  execute_test $2 $TEST_FILENAME "read" "stream" "true" "ruby tests/ruby/runner.rb"
}

ruby sh-scripts/generate-tests-files.rb
mkdir -p reports/results/read

FILES="$(echo `pwd`)/data/read/*"
for f in $FILES
do
  name=$(basename "$f" ".txt")
  echo "Running read benchmark for $name"

  truncate -s 0 reports/results/read/"$name".txt
  execute_all $f $name

  echo "> Done"
done
