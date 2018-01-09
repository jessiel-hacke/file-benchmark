require 'pry'

require_relative 'tests/read'
require_relative 'tests/write'
require_relative 'tests/parse'

module IOBench
  module Runner

    def self.start(env)
      file_path = env['TEST_FILE']
      test_type = env['TEST_TYPE']
      test_mode = (env['TEST_MODE'] || 'full')
      test_name = (ENV['TEST_NAME'] || File.basename(file_path))
      verbose   = (env['VERBOSE'] == 'true')

      args = [file_path, test_mode, test_name, verbose]

      raise('You must suply TEST_TYPE with one the values: read, write, read+write') if test_type.nil?

      if test_type == 'write'
        # avoid override if not test file is given for write tests
        # args[0] = "#{args[0]}.write" if File.exists?(args[0])
        args.unshift (env['KB_BLOCK_SIZE'] || 1).to_i
      end

      klass = test_type.downcase.capitalize
      bench = IOBench.const_get(klass).new(*args)
      bench.run
    end
  end
end


IOBench::Runner.start(ENV)