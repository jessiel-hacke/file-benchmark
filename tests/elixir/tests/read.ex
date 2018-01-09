defmodule IOBenchRead do
  def run(file_path, test_mode, verbose, test_name) do
    if verbose do
      print_test_type('read', test_mode, test_name)
    end

    pid = System.get_pid()

    memory_before = get_memory_usage(pid)

    time = :timer.tc(fn ->
      case test_mode do
        "full" -> test_full(file_path)
        "stream" -> test_stream(file_path)
        "stream_recursive" -> test_stream_recursive(file_path)
      end
    end)

    { elapsed_time, _ } = time

    memory_after = get_memory_usage(pid)

    if verbose do
      # time in milliseconds
      elapsed_time = elapsed_time/1000

      output_results(elapsed_time, memory_before, memory_after)
    end
  end

  defp print_memory_usage(memory_before, memory_after) do
    total_memory = ((memory_after - memory_before) / 1024.0);
    IO.puts "Memory: #{Float.round(total_memory,2)} MB"
  end

  defp print_execution_time(elapsed_time) do
    IO.puts "Time: #{Float.round(elapsed_time, 2)}ms"
  end

  defp output_results(elapsed_time, memory_before, memory_after) do
    print_memory_usage(memory_before, memory_after)
    print_execution_time(elapsed_time)
  end
  defp print_test_type(test_type, test_mode, test_name) do
    str = """
  Test Language: Elixir
  Test Language Version: #{System.version()}
  Test Type: #{test_type}
  Test Name: #{test_name}
  Test Mode: #{test_mode}
  """

    IO.write(str)
  end

  defp test_full(file_path) do
    File.read!(file_path)
  end

  defp test_stream(file_path) do
    file = File.open!(file_path)

    Enum.each IO.stream(file, :line), &on_read_stream_line(&1)
  end

  defp on_read_stream_line(line) do
    line # IO.puts line
  end

  # This method uses recursion
  defp test_stream_recursive(file_path) do
    file = File.open!(file_path)

    read_file(file)
  end

  defp read_file(file) do
    response = IO.read file, :line
    if response != :eof do
      read_file(file)
    end
  end

  defp get_memory_usage(_pid) do
    :erlang.memory[:total] / 1024.0
  end
end