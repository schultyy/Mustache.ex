defmodule Mustache.Mixfile do
  use Mix.Project

  def project do
    [app: :mustache,
     version: "0.3.1",
     elixir: "~> 1.0",
     package: package(),
     description: "Mustache templates for Elixir",
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [contributors: ["Jan Schulte"],
      licenses: ["MIT License"],
      maintainers: ["Jan Schulte"],
      links: %{"GitHub" => "https://github.com/schultyy/Mustache.ex"},
      files: ~w(mix.exs README.md lib)]
  end
end
