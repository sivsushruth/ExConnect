defmodule ExConnect.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_connect,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      applications: [:logger, :slack, :exirc, :gproc, :httpoison],
       mod: {ExConnect, []}
    ]
  end

  defp deps do
    [
      {:slack, "~> 0.7.0"},
      {:websocket_client, git: "https://github.com/jeremyong/websocket_client"},
      {:exirc, "~> 0.11.0"},
      {:gproc, git: "https://github.com/uwiger/gproc", tag: "0.6"},
      {:httpoison, git: "https://github.com/edgurgel/httpoison", override: true}
    ]
  end
end
