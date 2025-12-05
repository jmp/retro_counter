import Config

config :retro_counter,
  port: String.to_integer(System.get_env("RETRO_COUNTER_PORT", "4000")),
  count_path: System.get_env("RETRO_COUNTER_PATH", "count.txt"),
  write_delay: String.to_integer(System.get_env("RETRO_COUNTER_WRITE_DELAY", "30000"))

if config_env() == :test do
  temp_path =
    Path.join(System.tmp_dir!(), "retro_counter_global_#{System.unique_integer([:positive])}")

  File.touch!(temp_path)

  config :retro_counter,
    count_path: temp_path
end
