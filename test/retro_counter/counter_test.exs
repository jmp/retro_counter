defmodule RetroCounter.CounterTest do
  use ExUnit.Case, async: true

  @moduletag :tmp_dir

  setup %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "count")
    File.touch!(path)
    {:ok, path: path}
  end

  test "writes count to disk immediately with zero delay", %{path: path} do
    counter_pid = start_counter(path, write_delay: 0)

    count = GenServer.call(counter_pid, :increment)

    assert_receive :write
    assert read_current_count(path) == count
  end

  test "defers writing count to disk with nonzero delay", %{path: path} do
    counter_pid = start_counter(path, write_delay: :timer.seconds(30))

    GenServer.call(counter_pid, :increment)

    refute_receive :write
    assert File.read!(path) == ""
  end

  defp start_counter(path, overrides) do
    test_id = self()

    defaults = [
      count_path: path,
      write_callback: fn -> send(test_id, :write) end,
      name: nil
    ]

    start_supervised!({RetroCounter.Counter, Keyword.merge(defaults, overrides)})
  end

  defp read_current_count(path) do
    path
    |> File.read!()
    |> String.to_integer()
  end
end
