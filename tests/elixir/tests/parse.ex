defmodule IOBenchParse do
  def run(file_path, test_mode, verbose, test_name) do
    if verbose do
      print_test_type('parse', test_mode, test_name)
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
    |> String.split("\n")
    |> Enum.each(&on_read_stream_line(&1))
  end

  defp test_stream(file_path) do
    file = File.open!(file_path)

    Enum.each IO.stream(file, :line), &on_read_stream_line(&1)
  end

  defp on_read_stream_line(line) do
    parse(line) # IO.puts line
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

  @format [
    type:               2,
    sequential:         7,
    card_number:        19,
    auth_code:          6,
    sale_date:          8,
    sale_option:        1,
    sale_value:         15,
    installments:       3,
    zero0:              15,
    zero1:              15,
    zero2:              15,
    installment_value:  15,
    resume_number:      7,
    zero3:              3,
    entity_numbeer:     10,
    reserved0:          30,
    status:             2,
    payment_date:       8,
    expirty:            4,
    zero4:              7,
    zero5:              15,
    reserved1:          3,
    error_code:         4,
    ref:                11,
    new_card:           19,
    new_expiry:         4,
    reserved2:          2
  ]

  def parse(line) do
    { parsed_line, _acc } = Enum.flat_map_reduce(@format, 0, fn({key, size}, acc) ->
      { ["#{key}": String.slice(line, acc..(acc+size)) ], acc + size }
    end)
    parsed_line
  end
end
