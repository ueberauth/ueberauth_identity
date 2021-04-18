defmodule UeberauthIdentity.Mixfile do
  use Mix.Project

  @source_url "https://github.com/ueberauth/ueberauth_identity"
  @version "0.3.0"

  def project do
    [
      app: :ueberauth_identity,
      version: @version,
      name: "Üeberauth Identity",
      package: package(),
      elixir: "~> 1.2",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [
      applications: [:logger, :ueberauth]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.0"},
      {:ueberauth, "~> 0.6"},

      # dev/test dependencies
      {:credo, "~> 1.0", only: [:dev, :test]},
      {:dogma, ">= 0.0.0", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md",
        "CONTRIBUTING.md": [title: "Contributing"],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "#{@version}",
      formatters: ["html"]
    ]
  end

  defp package do
    [
      description: "An Ueberauth strategy for basic username/password",
      files: ["lib", "mix.exs", "CHANGELOG.md", "CONTRIBUTING.md", "LICENSE.md", "README.md"],
      maintainers: ["Daniel Neighman"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/ueberauth_identity/changelog.html",
        "GitHub" => @source_url
      }
    ]
  end
end
