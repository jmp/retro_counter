defmodule RetroCounter.CounterTest do
  use ExUnit.Case, async: true

  setup do
    filename = "retro_counter_test_#{System.unique_integer([:positive, :monotonic])}"
    path = Path.join(System.tmp_dir!(), filename)

    on_exit(fn ->
      File.rm(path)
    end)

    File.touch!(path)

    {:ok, path: path}
  end

  test "writes count to disk immediately with zero delay", %{path: path} do
    pid = self()

    RetroCounter.Counter.start_link(
      count_path: path,
      name: :test_immediate,
      write_delay: 0,
      write_callback: fn -> send(pid, :write) end
    )

    count = GenServer.call(:test_immediate, :increment)

    assert_receive :write
    assert read_integer(path) == count
  end

  test "defers writing count to disk with nonzero delay", %{path: path} do
    pid = self()

    RetroCounter.Counter.start_link(
      count_path: path,
      name: :test_deferred,
      write_delay: :timer.seconds(30),
      write_callback: fn -> send(pid, :write) end
    )

    GenServer.call(:test_deferred, :increment)

    refute_receive :write
    assert_raise(ArgumentError, fn -> read_integer(path) end)
  end

  defp read_integer(path) do
    String.to_integer(File.read!(path))
  end
end
