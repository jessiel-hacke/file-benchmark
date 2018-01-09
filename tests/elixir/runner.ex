Code.require_file("tests/read.ex", __DIR__)
Code.require_file("tests/write.ex", __DIR__)
Code.require_file("tests/parse.ex", __DIR__)

file_path = System.get_env("TEST_FILE")
verbose = System.get_env("VERBOSE") == "true"
test_mode = (System.get_env("TEST_MODE") || "full")
test_name = System.get_env("TEST_NAME")
test_type = System.get_env("TEST_TYPE")
block_size = System.get_env("KB_BLOCK_SIZE") || 1

if test_type == "" or test_type == nil do
  raise("You must supply TEST_TYPE")
end

if test_type == "read" do
  IOBenchRead.run(file_path, test_mode, verbose, test_name)
end

if test_type == "parse" do
  IOBenchParse.run(file_path, test_mode, verbose, test_name)
end

if test_type == "write" do
  { block_size, _ } = Integer.parse(block_size)
  IOBenchWrite.run(block_size, file_path, test_mode, verbose, test_name)
end