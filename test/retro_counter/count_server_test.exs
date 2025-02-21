defmodule RetroCounter.CountServerTest do
  use ExUnit.Case
  alias RetroCounter.CountServer

  test "writes count to disk at scheduled intervals" do
    pid = self()
    CountServer.start_link("count.txt", :test, 0, fn -> send(pid, :write_count) end)

    wait_for_message(:write_count)
    wait_for_message(:write_count)

    count = read_integer("count.txt")
    assert count == 0
  end

  defp read_integer(path) do
    String.to_integer(File.read!(path))
  end

  defp wait_for_message(message) do
    receive do
      ^message -> nil
    end
  end
end
