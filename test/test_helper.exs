ExUnit.start()

ExUnit.after_suite(fn _results ->
  path = Application.get_env(:retro_counter, :count_path)

  if path && File.exists?(path) do
    File.rm(path)
  end
end)
