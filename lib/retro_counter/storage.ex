defmodule RetroCounter.Storage do
  def read_integer(path) do
    File.read!(path)
    |> String.to_integer()
  rescue
    _ -> 0
  end

  def write_integer(count, path) do
    :ok = File.write(path, to_string(count))
  end
end
