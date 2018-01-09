require "./tests/read"
require "./tests/write"
require "./tests/parse"

module IOBench
  module Runner
    def self.start(env)
      file_path = env["TEST_FILE"]
      test_type = env["TEST_TYPE"]
      test_mode = (env["TEST_MODE"] || "full")
      test_name = (env["TEST_NAME"] || File.basename(file_path))
      verbose = (env["VERBOSE"] == "true")

      raise("You must suply TEST_TYPE with one the values: read, write, read+write") if test_type.nil?

      if test_type == "read"
        bench = IOBench::Read.new(file_path, test_mode, test_name, verbose)
        bench.run
      elsif test_type == "write"
        block_size = (ENV["KB_BLOCK_SIZE"] || 1).to_i

        bench = IOBench::Write.new(block_size, file_path, test_mode, test_name, verbose)
        bench.run
      elsif test_type == "parse"
        bench = IOBench::Parse.new(file_path, test_mode, test_name, verbose)
        bench.run
      end
    end
  end
end

IOBench::Runner.start(ENV)
