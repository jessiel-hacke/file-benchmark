require "./base"

module IOBench
  class Read < Base
    def test_full(file_path)
      File.read(file_path)
    end

    def test_stream(file_path)
      File.each_line(file_path) do |line|
        line
      end
    end

    def test_type
      "read"
    end
  end
end
