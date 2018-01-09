require_relative 'base.rb'

module IOBench
  class Read < Base
    private
    def test_full(file_path)
      IO.read(file_path)
    end

    def test_stream(file_path)
      IO.foreach(file_path) do |line|
        line
      end
    end

    def test_type
      'read'
    end
  end
end