defmodule PlugSessionPg.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_session_pg,
      version: "0.1.0",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.0"},
      {:ecto, "~> 2.1"},
      {:postgrex, ">= 0.0.0", only: :test},
      {:poison, "~> 3.1"}
    ]
  end

  defp aliases do
    [
      "test": ["ecto.create --quiet", "ecto.migrate", "test"],
    ]
  end
end
