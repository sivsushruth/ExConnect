use Mix.Config

config :ex_connect_app, ExConnectApp.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn
