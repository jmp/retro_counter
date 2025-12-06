defmodule RetroCounter.CounterTest do
  use ExUnit.Case, async: true

  setup do
    filename = "retro_counter_test_#{System.unique_integer([:positive, :monotonic])}"
    path = Path.join(System.tmp_dir!(), filename)

    on_exit(fn -> File.rm(path) end)

    File.touch!(path)

    {:ok, path: path}
  end

  test "writes count to disk immediately with zero delay", %{path: path} do
    test_pid = self()

    counter_pid =
      start_supervised!(
        {RetroCounter.Counter,
         [
           count_path: path,
           write_delay: 0,
           write_callback: fn -> send(test_pid, :write) end,
           name: nil
         ]}
      )

    count = GenServer.call(counter_pid, :increment)

    assert_receive :write
    assert read_current_count(path) == count
  end

  test "defers writing count to disk with nonzero delay", %{path: path} do
    test_pid = self()

    counter_pid =
      start_supervised!(
        {RetroCounter.Counter,
         [
           count_path: path,
           write_delay: :timer.seconds(30),
           write_callback: fn -> send(test_pid, :write) end,
           name: nil
         ]}
      )

    GenServer.call(counter_pid, :increment)

    refute_receive :write
    assert File.read!(path) == ""
  end

  defp read_current_count(path) do
    path
    |> File.read!()
    |> String.to_integer()
  end
end
