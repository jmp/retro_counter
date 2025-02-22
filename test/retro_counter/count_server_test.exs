defmodule RetroCounter.CountServerTest do
  use ExUnit.Case

  test "writes count to disk immediately with zero delay" do
    pid = self()
    path = Briefly.create!()

    RetroCounter.CountServer.start_link(
      count_path: path,
      name: :test,
      write_delay: 0,
      write_callback: fn -> send(pid, :write) end
    )

    count = GenServer.call(:test, :increment)

    assert_receive :write
    assert read_integer(path) == count
  end

  test "defers writing count to disk with nonzero delay" do
    pid = self()
    path = Briefly.create!()

    RetroCounter.CountServer.start_link(
      count_path: path,
      name: :test,
      write_delay: :timer.seconds(30),
      write_callback: fn -> send(pid, :write) end
    )

    GenServer.call(:test, :increment)

    refute_receive :write
    assert_raise(ArgumentError, fn -> read_integer(path) end)
  end

  defp read_integer(path) do
    String.to_integer(File.read!(path))
  end
end
