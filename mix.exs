defmodule RetroCounter.MixProject do
  use Mix.Project

  def project do
    [
      app: :retro_counter,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :inets],
      mod: {RetroCounter, []}
    ]
  end

  defp deps do
    [
      {:bandit, "~> 1.9"}
    ]
  end
end
