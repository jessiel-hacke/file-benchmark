#!/bin/bash

# execute_file(command, test_file, test_type, test_mode, verbose)
execute_test() {
  start=$(date +%s.%N)

  COMMAND="TEST_NAME='$1' TEST_FILE='$2' TEST_TYPE='$3' TEST_MODE='$4' VERBOSE='$5' $6 >> reports/results/parse/$1.txt"

  eval $COMMAND

  dur=$(echo "$(date +%s.%N) - $start" | bc)

  LC_NUMERIC="C.UTF-8" printf "Shell Execution Time: %.4fs\n\n" $dur >> reports/results/parse/"$1".txt
}

execute_all() {
  TEST_FILENAME=$1

  execute_test $2 $TEST_FILENAME "parse" "full" "true" "crystal tests/crystal/runner.cr"
  # Crystal (Stream)
  execute_test $2 $TEST_FILENAME "parse" "stream" "true" "crystal tests/crystal/runner.cr"

  # Elixir (Full)
  execute_test $2 $TEST_FILENAME "parse" "full" "true" "elixir tests/elixir/runner.ex"
  # Elixir (Stream)
  execute_test $2 $TEST_FILENAME "parse" "stream" "true" "elixir tests/elixir/runner.ex"

  # GoLang (Full)
  execute_test $2 $TEST_FILENAME "parse" "full" "true" "go run tests/go/parse.go"
  # GoLang (Stream)
  execute_test $2 $TEST_FILENAME "parse" "stream" "true" "go run tests/go/parse.go"

  # Lua (Full)
  execute_test $2 $TEST_FILENAME "parse" "full" "true" "lua tests/lua/parse.lua"
  # Lua (Stream)
  execute_test $2 $TEST_FILENAME "parse" "stream" "true" "lua tests/lua/parse.lua"

  # NodeJS (Full)
  execute_test $2 $TEST_FILENAME "parse" "full" "true" "node tests/nodejs/runner.js"
  # NodeJS (Stream)
  execute_test $2 $TEST_FILENAME "parse" "stream" "true" "node tests/nodejs/runner.js"

  # Python (Full)
  execute_test $2 $TEST_FILENAME "parse" "full" "true" "python tests/python/runner.py"
  # Python (Stream)
  execute_test $2 $TEST_FILENAME "parse" "stream" "true" "python tests/python/runner.py"

  # Ruby (Full)
  execute_test $2 $TEST_FILENAME "parse" "full" "true" "ruby tests/ruby/runner.rb"
  # Ruby (Stream)
  execute_test $2 $TEST_FILENAME "parse" "stream" "true" "ruby tests/ruby/runner.rb"
}

ruby sh-scripts/generate-tests-files.rb
mkdir -p reports/results/parse

FILES="$(echo `pwd`)/data/parse/*"
for f in $FILES
do
  name=$(basename "$f" ".txt")
  echo "Running benchmark for $name"
  truncate -s 0 reports/results/parse/"$name".txt
  execute_all $f $name
done
