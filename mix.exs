defmodule DstarEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :dstarex,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: description(),
      deps: deps(),
      name: "DstarEx",
      source_url: "https://github.com/lfaudreejr/Datastar-SSE-Elixir"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Datastar Elixir"
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:plug, "~>1.18.1"},
      {:jason, "~> 1.4"},
      {:bandit, "~> 1.0", only: :dev}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{},
      exclude_patterns: ["lib/scripts"]
    ]
  end
end
