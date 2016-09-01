defmodule ExBridge.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_bridge,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :slack, :exirc, :gproc, :httpoison],
       mod: {ExBridge, []}
    ]
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
    [
      {:slack, "~> 0.7.0"},
      {:websocket_client, git: "https://github.com/jeremyong/websocket_client"},
      {:exirc, "~> 0.11.0"},
      {:gproc, "~> 0.5.0"},
      {:httpoison, "~> 0.9.0", override: true}
    ]
  end
end
