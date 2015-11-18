defmodule UeberauthIdentity.Mixfile do
  use Mix.Project

  @version "0.1.1"

  def project do
    [app: :ueberauth_identity,
     version: @version,
     name: "Ueberauth Identity",
     package: package,
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     source_url: "https://github.com/hassox/ueberauth_identity",
     homepage_url: "https://github.com/hassox/ueberauth_identity",
     description: description,
     deps: deps,
     docs: docs]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:ueberauth, "~> 0.1"},
      {:plug, "~> 1.0"},

      # docs dependencies
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.1", only: :dev}
    ]
  end

  defp docs do
    [extras: docs_extras, main: "extra-readme"]
  end

  defp docs_extras do
    ["README.md"]
  end

  defp description do
    "An Ueberauth strategy for basic username/password"
  end

  defp package do
    [files: ["lib", "mix.ex", "README.md", "LICENSE"],
      maintainers: ["Daniel Neighman"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/hassox/ueberauth_identity"}]
  end
end
