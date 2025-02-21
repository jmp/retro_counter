defmodule RetroCounter.Storage do
  def read_integer(path) do
    File.read!(path)
    |> String.to_integer()
  rescue
    _ -> 0
  end

  def write_integer(count, path) do
    case File.write(path, to_string(count)) do
      :ok -> count
      _ -> 0
    end
  end
end
