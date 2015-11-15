defmodule UeberIdentity.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :ueber_identity,
     version: @version,
     name: "Ueber Identity",
     package: package,
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     source_url: "https://github.com/hassox/ueber_identity",
     homepage_url: "https://github.com/hassox/ueber_identity",
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
      links: %{github: "https://github.com/hassox/ueber_identity"}]
  end
end
