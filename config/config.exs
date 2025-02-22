import Config

config :retro_counter,
  port: 4000,
  count_path: "count.txt",
  write_delay: :timer.seconds(30)
