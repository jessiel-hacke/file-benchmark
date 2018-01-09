require_relative 'base.rb'

module IOBench
  class Write < Base
    include Helpers

    BYTES_PER_LINE = 1024 # 1 kb
    DUMMY_CHARACTER = " " # space as 1 byte char

    def initialize(block_size, *args)
      @block_size = block_size.to_i

      super(*args)

      clear_file
    end

    def test_type
      'write'
    end

    private
    def generate_dummy_data(block_size=1)
      data = DUMMY_CHARACTER * (BYTES_PER_LINE * block_size) << "\n"
    end

    def test_full(file_path)
      file = File.open(file_path, 'wb')
      file.puts(generate_dummy_data(@block_size))
      file.flush
    end

    def test_stream(file_path)
      file = File.open(file_path, 'wb')

      @block_size.times do
        file.puts(generate_dummy_data(1))
      end

      file.flush
    end
  end
end