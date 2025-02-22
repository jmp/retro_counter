defmodule RetroCounter do
  use Application

  def start(_type, _args) do
    count_path = Application.fetch_env!(:retro_counter, :count_path)

    children = [
      {Bandit, plug: RetroCounter.Router},
      {RetroCounter.CountServer, [count_path: count_path]}
    ]

    opts = [strategy: :one_for_one, name: RetroCounter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
