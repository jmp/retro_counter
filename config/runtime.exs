import Config

if config_env() == :test do
  {:ok, _} = Application.ensure_all_started(:briefly)

  config :retro_counter, count_path: Briefly.create!()
end
