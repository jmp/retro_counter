defmodule RetroCounter.Storage do
  def write_integer(count, path) do
    case File.write(path, to_string(count)) do
      :ok -> count
      _ -> 0
    end
  end
end
