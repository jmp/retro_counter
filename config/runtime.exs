import Config

config :retro_counter,
  count_path: System.get_env("RETRO_COUNTER_PATH", "count.txt"),
  write_delay: String.to_integer(System.get_env("RETRO_COUNTER_WRITE_DELAY", "30000"))

if config_env() == :test do
  {:ok, _} = Application.ensure_all_started(:briefly)

  config :retro_counter,
    count_path: Briefly.create!()
end
