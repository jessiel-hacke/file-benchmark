require 'benchmark'

module IOBench
  module Helpers
    def capture_memory_usage(pid)
      `ps -o rss= -p #{pid}`.to_i
    end

    def with_memory_usage(&block)
      memory_before = capture_memory_usage(Process.pid)
      yield block if block_given?
      memory_after = capture_memory_usage(Process.pid)

      return [memory_before, memory_after]
    end

    def with_execution_time(&block)
      start_time = Time.now
      yield block

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

    def run_with_metrics(&block)
      memory_before = memory_after = 0

      elapsed_time = with_execution_time do
        memory_before, memory_after = with_memory_usage(&block)
      end

      return {
        elapsed_time: elapsed_time,
        memory_before: memory_before,
        memory_after: memory_after
      }
    end

    def output_results(metrics)
      print_results(metrics[:elapsed_time], metrics[:memory_before], metrics[:memory_after])
    end
  end

  class Base
    include Helpers

    def initialize(file_path, test_mode = 'full', test_name = "", verbose = true)
      @file_path = file_path
      @test_mode = test_mode
      @test_name = test_name
      @verbose = verbose
    end

    def run
      print_test_type if verbose?

      metrics = run_with_metrics do
        method_name = "test_#{@test_mode}"
        send(method_name, @file_path) if self.respond_to?(method_name, true)
      end

      output_results(metrics) if verbose?
    end

    def verbose?
      @verbose == true
    end

    private
    def print_test_type
      print(test_type_label)
    end

    def test_type_label
      str = <<-EOF
        Test Language: Ruby
        Test Language Version: #{RUBY_VERSION}
        Test Type: #{test_type}
        Test Name: #{@test_name}
        Test Mode: #{@test_mode}
      EOF

      str.gsub(/^\s+/, '')
    end

    def clear_file
      File.truncate(@file_path, 0) if File.exists?(@file_path)
    end
  end
end