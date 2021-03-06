defmodule Belixir.Mixfile do
  use Mix.Project

  def project do
    [app: :belixir,
     version: "0.2.0",
     elixir: "~> 1.2",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
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
  # Type "mix help deps" for more examples and options
  defp deps do
    []
  end

  defp description do
    """
    Benchmark ips tool for elixir-lang. Runs given codes in given seconds and compares them.
    """
  end

  defp package do
    [
      maintainers: ["Mehmet Emin İNAÇ"],
      links: %{"GitHub" => "https://github.com/meinac/belixir"},
      licenses: ["MIT"]
    ]
  end
end
