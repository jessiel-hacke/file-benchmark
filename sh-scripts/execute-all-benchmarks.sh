execute_all_parse() {
  ./sh-scripts/bench-parse-all.sh
}
execute_all_read() {
  ./sh-scripts/bench-read-all.sh
}

execute_all_write() {
  ./sh-scripts/bench-write-all.sh
}

echo "Generating test files..."
ruby ./sh-scripts/generate-tests-files.rb
echo "> Done"

echo "Executing I/O Read Benchmarks. This could take a while..."
execute_all_read
echo "> Done"

echo "Executing I/O Write Benchmarks. This could take a while..."
execute_all_write
echo "> Done"

echo "Executing I/O Parse Benchmarks. This could take a while..."
execute_all_parse
echo "> Done"
