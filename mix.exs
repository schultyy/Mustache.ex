defmodule Mustache.Mixfile do
  use Mix.Project

  @source_url "https://github.com/schultyy/Mustache.ex"
  @version "0.4.0"

  def project do
    [
      app: :mustache,
      version: @version,
      elixir: "~> 1.0",
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp package do
    [
      description: "A Mustache implementation for Elixir",
      contributors: ["Jan Schulte"],
      licenses: ["MIT"],
      maintainers: ["Jan Schulte"],
      files: ~w(mix.exs README.md LICENSE.md lib),
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
