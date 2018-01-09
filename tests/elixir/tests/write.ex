defmodule IOBenchWrite do

  @bytes_per_line 1024 # 1 kb
  @dummy_character " " # space as 1 byte char

  def run(block_size, file_path, test_mode, verbose, test_name) do
    if verbose do
      print_test_type('write', test_mode, test_name)
    end

    pid = System.get_pid()

    memory_before = get_memory_usage(pid)

    time = :timer.tc(fn ->
      case test_mode do
        "full" -> test_full(file_path, block_size)
        "stream" -> test_stream(file_path, block_size)
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

  defp generate_dummy_data(block_size) do
    String.duplicate(@dummy_character, (block_size * @bytes_per_line))
  end

  defp test_full(file_path, block_size) do
    content = generate_dummy_data(block_size)
    File.write!(file_path, content)
  end

  defp test_stream(file_path, block_size) do
    file = File.open!(file_path, [:write])

    Enum.each(1..block_size, fn(_i) ->
      content = generate_dummy_data(1)
      IO.write(file, content)
    end)
  end

  defp get_memory_usage(_pid) do
    :erlang.memory[:total] / 1024.0
  end
end