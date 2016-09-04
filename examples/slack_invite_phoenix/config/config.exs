use Mix.Config

config :ex_connect_app, ExConnectApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RAm0zDO46ZY6AjdhHQrG+zgcbg42lHUyM/IQa5cL9bAv6aySmRPsHhxsr2W+UzvR",
  render_errors: [view: ExConnectApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExConnectApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
config :ex_connect,
        slack_token: "xxx",
        bots: [
            %{
                :server => "chat.freenode.net",
                :port => 8000,
                :nick => "slack_bot",
                :user => "slack_bot",
                :name => "Slack Bot",
                :channel => "#bridge_test"
            }
        ],
        irc_prefix: "slack_",
        admin_token: "xxx"

