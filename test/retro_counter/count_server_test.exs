defmodule RetroCounter.CountServerTest do
  use ExUnit.Case
  alias RetroCounter.CountServer

  test "writes count to disk at scheduled intervals" do
    pid = self()
    path = Briefly.create!()

    CountServer.start_link(
      count_path: path,
      name: :test,
      write_interval: 0,
      write_callback: fn -> send(pid, :write) end
    )

    assert_receive :write
    assert_receive :write

    count = read_integer(path)
    assert count == 0
  end

  defp read_integer(path) do
    String.to_integer(File.read!(path))
  end
end
