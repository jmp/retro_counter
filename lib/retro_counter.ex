defmodule RetroCounter do
  use Application

  def start(_type, _args) do
    port = Application.fetch_env!(:retro_counter, :port)
    count_path = Application.fetch_env!(:retro_counter, :count_path)
    write_delay = Application.fetch_env!(:retro_counter, :write_delay)

    children = [
      {Bandit, plug: RetroCounter.Router, port: port},
      {RetroCounter.Counter, [count_path: count_path, write_delay: write_delay]}
    ]

    opts = [strategy: :one_for_one, name: RetroCounter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
