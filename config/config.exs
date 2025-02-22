import Config

config :retro_counter,
  count_path: "count.txt",
  write_delay: :timer.seconds(30)
