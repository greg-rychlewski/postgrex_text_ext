defmodule PostgrexTextExt.MixProject do
  use Mix.Project

  @source_url "https://github.com/greg-rychlewski/postgrex_text_ext"
  @version "0.1.0"

  def project do
    [
      app: :postgrex_text_ext,
      version: @version,
      elixir: "~> 1.6",
      name: "PostgrexTextExt",
      description: "Text Extensions for Postgrex",
      docs: docs(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :docs},
      {:postgrex, ">= 0.0.0"}
    ]
  end

  defp docs do
    [
      source_url: @source_url,
      source_ref: "v#{@version}",
      main: "readme",
      extras: ["README.md", "CHANGELOG.md"],
    ]
  end

  defp package do
    [
      maintainers: ["Greg Rychlewski"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url},
      files:
        ~w(.formatter.exs mix.exs README.md CHANGELOG.md lib)
    ]
  end
end
