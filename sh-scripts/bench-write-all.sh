#!/bin/bash

execute_test() {
  start=$(date +%s.%N)
  log_name=$(basename $3 ".write")

  COMMAND="KB_BLOCK_SIZE='$1' TEST_NAME='$2' TEST_FILE='$3' TEST_TYPE='$4' TEST_MODE='$5' VERBOSE='$6' $7 >> reports/results/write/${log_name}.txt"

  eval $COMMAND

  dur=$(echo "$(date +%s.%N) - $start" | bc)

  LC_NUMERIC="C.UTF-8" printf "Shell Execution Time: %.4fs\n\n" $dur >> reports/results/write/"$log_name".txt
}

create_dirs() {
  mkdir -p $1/data/crystal
  mkdir -p $1/data/elixir
  mkdir -p $1/data/lua
  mkdir -p $1/data/nodejs
  mkdir -p $1/data/python
  mkdir -p $1/data/ruby

  mkdir -p $1/reports/results/write

}

execute_all() {
  # Crystal (Full)
  execute_test $1 $2 "$4/data/crystal/$3.write" "write" "full" "true" "crystal tests/crystal/runner.cr"
  # Crystal (Stream)
  execute_test $1 $2 "$4/data/crystal/$3.write" "write" "stream" "true" "crystal tests/crystal/runner.cr"
  rm "$4/data/crystal/$3.write"

  # Elixir (Full)
  execute_test $1 $2 "$4/data/elixir/$3.write" "write" "full" "true" "elixir tests/elixir/runner.ex"
  # Elixir (Stream)
  execute_test $1 $2 "$4/data/elixir/$3.write" "write" "stream" "true" "elixir tests/elixir/runner.ex"
  rm "$4/data/elixir/$3.write"

  # Lua (Full)
  execute_test $1 $2 "$4/data/lua/$3.write" "write" "full" "true" "lua tests/lua/write.lua"
  # Lua (Stream)
  execute_test $1 $2 "$4/data/lua/$3.write" "write" "stream" "true" "lua tests/lua/write.lua"
  rm "$4/data/lua/$3.write"

  # Go (Full)
  execute_test $1 $2 "$4/data/go/$3.write" "write" "full" "true" "go run tests/go/write.go"
  # Go (Stream)
  execute_test $1 $2 "$4/data/go/$3.write" "write" "stream" "true" "go run tests/go/write.go"
  rm "$4/data/go/$3.write"

  # NodeJS (Full)
  execute_test $1 $2 "$4/data/nodejs/$3.write" "write" "full" "true" "node tests/nodejs/runner.js"
  # NodeJS (Stream)
  execute_test $1 $2 "$4/data/nodejs/$3.write" "write" "stream" "true" "node tests/nodejs/runner.js"
  rm "$4/data/nodejs/$3.write"

  # Ruby (Full)
  execute_test $1 $2 "$4/data/ruby/$3.write" "write" "full" "true" "ruby tests/ruby/runner.rb"
  # Ruby (Stream)
  execute_test $1 $2 "$4/data/ruby/$3.write" "write" "stream" "true" "ruby tests/ruby/runner.rb"
  rm "$4/data/ruby/$3.write"

  # Python (Full)
  execute_test $1 $2 "$4/data/python/$3.write" "write" "full" "true"  "python tests/python/runner.py"
  # Python (Stream)
  execute_test $1 $2 "$4/data/python/$3.write" "write" "stream" "true" "python tests/python/runner.py"
  rm "$4/data/python/$3.write"
}


BASEDIR=`pwd`
FILES="$(echo $BASEDIR)/data/read/*.txt"

create_dirs $BASEDIR

for f in $FILES
do
  name=$(basename "$f" ".txt")
  echo "Running write benchmark for $name"

  truncate -s 0 reports/results/write/"$name".txt
  size=${name//"_"}

  if [[ $size == *"mb" ]]; then
    block_size=$((${size//"mb"} * 1024))
  else
    block_size=${size//"kb"}
  fi

  execute_all $block_size $size $name $BASEDIR

  echo "> Done"
done
