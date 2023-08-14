defmodule Mustache.Mixfile do
  use Mix.Project

  @version "0.5.1"
  @source_url "https://github.com/schultyy/mustache.ex"

  def project do
    [
      app: :mustache,
      version: @version,
      elixir: "~> 1.15",
      package: package(),
      description: description(),
      deps: deps(),
      docs: docs()
    ]
  end

  defp description do
    "A Mustache Implementation in Elixir"
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
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
