defmodule RetroCounter do
  use Application

  def start(_type, _args) do
    children = [
      {Bandit, plug: RetroCounter.Router},
      {RetroCounter.CountServer, []}
    ]

    opts = [strategy: :one_for_one, name: RetroCounter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
