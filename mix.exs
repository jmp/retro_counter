defmodule RetroCounter.MixProject do
  use Mix.Project

  def project do
    [
      app: :retro_counter,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {RetroCounter, []}
    ]
  end

  defp deps do
    [
      {:bandit, "~> 1.6"},
      {:req, "~> 0.5.0", only: :test}
    ]
  end
end
