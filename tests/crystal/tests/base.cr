module IOBench
  module Helpers
    def capture_memory_usage(pid)
      `ps -o rss= -p #{pid}`.to_i
    end

    # source: http://dalibornasevic.com/posts/68-processing-large-csv-files-with-ruby
    def with_memory_usage(&block)
      memory_before = capture_memory_usage(Process.pid)
      yield
      memory_after = capture_memory_usage(Process.pid)

      return [memory_before, memory_after]
    end

    def with_execution_time(&block)
      start_time = Time.now
      yield &block

      return (Time.now - start_time).to_f
    end

    def print_memory_usage(memory_before, memory_after)
      memory = ((memory_after - memory_before) / 1024.0)
      puts "Memory: #{memory.round(2)} MB"
    end

    def print_execution_time(time)
      puts "Time: #{time.round(2) * 1000}ms"
    end

    def print_results(elapsed_time, memory_before, memory_after)
      print_memory_usage(memory_before, memory_after)
      print_execution_time(elapsed_time)
    end
  end

  class Base
    include Helpers

    def initialize(file_path : String, test_mode : String = :full, test_name : String = "", verbose : Bool = false)
      @file_path = file_path
      @test_mode = test_mode
      @test_name = test_name
      @verbose = verbose
    end

    def run
      print_test_type if verbose?

      memory_before = memory_after = 0

      elapsed_time = with_execution_time do
        memory_before, memory_after = with_memory_usage do
          if @test_mode == "full"
            test_full(@file_path)
          elsif @test_mode == "stream"
            test_stream(@file_path)
          end
        end
      end

      print_results(elapsed_time, memory_before, memory_after) if verbose?
    end

    def verbose?
      @verbose == true
    end

    private def clear_file
      `truncate -s 0 #{@file_path}` if File.exists?(@file_path)
    end

    private def print_test_type
      print(test_type_label)
    end

    private def test_type_label
      version = `crystal -v`.strip
      str = <<-EOF
      Test Language: Crystal
      Test Language Version: #{version}
      Test Type: #{test_type}
      Test Name: #{@test_name}
      Test Mode: #{@test_mode}\n
      EOF
    end
  end
end
